//
//  CXZoomGesture.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

/// A view modifier that adds zoom gesture support to a view.
/// This gesture recognizer provides pinch-to-zoom functionality with support for
/// double-tap zooming and bounds checking to ensure content stays within view.
@available(iOS 17.0, *)
public struct CXZoomGesture: ViewModifier {

    // MARK: - Constants

    /// Maximum allowed zoom scale
    private static let maxZoomScale: CGFloat = 3.0
    /// Number of taps required for double-tap zoom
    private static let numOfTapRequired: Int = 2

    /// Configuration options for the zoom gesture
    public struct Config {
        /// Available size for the content
        var availableSize: CGSize
        /// Whether the gesture is disabled
        var isDisabled: Bool
        /// Whether double-tap zoom is enabled
        var isDoubleTapEnabled: Bool
        /// Duration of the zoom animation
        var animationDuration: TimeInterval

        public init(
            availableSize: CGSize,
            isDisabled: Bool = false,
            isDoubleTapEnabled: Bool = true,
            animationDuration: TimeInterval = CXAnimation.Duration.quick
        ) {
            self.isDisabled = isDisabled
            self.isDoubleTapEnabled = isDoubleTapEnabled
            self.availableSize = availableSize
            self.animationDuration = animationDuration
        }
    }

    // MARK: - Properties

    /// Configuration for the gesture behavior
    var config: Config
    /// Binding to track zoom state
    @Binding var isZoomIn: Bool
    /// Optional action to perform on double tap
    var onDoubleTap: CXNoArgumentAction?

    // MARK: - Private properties

    /// Current content size
    @State private var contentSize: CGSize = .zero
    /// Current transform applied to content
    @State private var transform: CGAffineTransform = .identity
    /// Latest transform state for gesture updates
    @State private var latestTransform: CGAffineTransform = .identity
    /// Current zoom scale
    @State private var zoomScale: CGFloat = 1.0
    /// Maximum allowed zoom scale, adjusted based on content
    @State private var maxZoomScale = CXZoomGesture.maxZoomScale

    /// Double tap gesture recognizer
    private var doubleTapGesture: some Gesture {
        SpatialTapGesture(count: CXZoomGesture.numOfTapRequired)
            .onEnded { gesture in
                guard config.isDoubleTapEnabled else { return }

                if let onDoubleTap {
                    onDoubleTap()
                } else {
                    toggleZoom(value: gesture)
                }
            }
    }

    /// Drag gesture recognizer for panning zoomed content
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation(.interactiveSpring) {
                    transform = latestTransform.translatedBy(
                        x: gesture.translation.width / transform.scaleX,
                        y: gesture.translation.height / transform.scaleY
                    )
                }
            }
            .onEnded { _ in
                let dragEndTransform = makeDragEndTransform(transform: transform, zoomScale: zoomScale)
                withAnimation(.snappy(duration: config.animationDuration)) {
                    transform = dragEndTransform
                    latestTransform = dragEndTransform
                    zoomScale = dragEndTransform.scaleX
                }
            }
    }

    /// Magnification gesture recognizer for zooming
    private var magnifyGesture: some Gesture {
        MagnifyGesture(minimumScaleDelta: 0)
            .onChanged { gesture in
                let zoomedTransform = makeMagnifyTransform(scale: gesture.magnification, anchor: gesture.startAnchor.scaledBy(contentSize))
                withAnimation(.interactiveSpring) {
                    transform = latestTransform.concatenating(zoomedTransform)
                }
            }
            .onEnded { gesture in
                let zoomedTransform = makeMagnifyEndTransform(anchor: gesture.startLocation)
                let finalizedTransform = makeDragEndTransform(
                    transform: zoomedTransform,
                    zoomScale: zoomedTransform.scaleX
                )

                withAnimation(.snappy(duration: config.animationDuration)) {
                    self.transform = finalizedTransform
                    latestTransform = finalizedTransform
                    zoomScale = finalizedTransform.scaleX
                }
            }
    }

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        content
            .zoomTransformEffect(transform)
            .gesture(dragGesture, including: isZoomIn ? .all : .subviews)
            .gesture(doubleTapGesture, including: config.isDisabled ? .none : .all)
            .gesture(magnifyGesture, including: config.isDisabled ? .none : .all)
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                contentSize = newValue
            }
            .onChange(of: contentSize) { newValue in
                maxZoomScale = CXZoomGesture.updateMaxZoomScale(
                    content: newValue,
                    screen: config.availableSize,
                    maxZoomScale: maxZoomScale
                )
            }
            .onChange(of: zoomScale) { zoomScale in
                withAnimation(.snappy(duration: config.animationDuration)) {
                    isZoomIn = zoomScale > 1.0
                }
            }
            .onChange(of: isZoomIn) { isZoomIn in
                if !isZoomIn {
                    withAnimation(.snappy(duration: config.animationDuration)) {
                        transform = .identity
                        latestTransform = .identity
                        zoomScale = 1.0
                    }
                }
            }
    }

    // MARK: - Private methods

    /// Toggles zoom state based on double tap location
    private func toggleZoom(value: SpatialTapGesture.Value) {
        let zoomedTransform = makeDoubleTapTransform(location: value.location)
        withAnimation(.snappy(duration: config.animationDuration)) {
            transform = zoomedTransform
            latestTransform = zoomedTransform
            zoomScale = zoomedTransform.scaleX
        }
    }

    /// Creates transform for drag gesture end state
    private func makeDragEndTransform(transform: CGAffineTransform, zoomScale: CGFloat) -> CGAffineTransform {
        if transform.scaleX < 1.0 || transform.scaleY < 1.0 {
            return .identity
        }

        let zoomedSize = contentSize * zoomScale
        let zoomedContentOrigin = CXZoomGesture.makeZoomedContentOrigin(
            content: contentSize,
            screen: config.availableSize
        )

        var tx = transform.tx
        var ty = transform.ty

        if zoomedSize.height >= config.availableSize.height {
            if ty >= zoomedContentOrigin.y {
                ty = zoomedContentOrigin.y
            } else if -(ty - zoomedContentOrigin.y) + config.availableSize.height > zoomedSize.height {
                ty = zoomedContentOrigin.y - (zoomedSize.height - config.availableSize.height)
            }
        } else {
            ty = zoomedContentOrigin.y + (config.availableSize.height - zoomedSize.height) / 2.0
        }

        if zoomedSize.width >= config.availableSize.width {
            if tx >= zoomedContentOrigin.x {
                tx = zoomedContentOrigin.x
            } else if -(tx - zoomedContentOrigin.x) + config.availableSize.width > zoomedSize.width {
                tx = zoomedContentOrigin.x - (zoomedSize.width - config.availableSize.width)
            }
        } else {
            tx = zoomedContentOrigin.x + (config.availableSize.width - zoomedSize.width) / 2.0
        }

        var updatedTransform = transform
        updatedTransform.tx = tx
        updatedTransform.ty = ty

        return updatedTransform
    }

    /// Creates transform for magnification gesture
    private func makeMagnifyTransform(scale: CGFloat, anchor: CGPoint) -> CGAffineTransform {
        CGAffineTransform.anchoredScale(scale: scale, anchor: anchor)
    }

    /// Creates transform for double tap zoom
    private func makeDoubleTapTransform(location: CGPoint) -> CGAffineTransform {
        guard transform.isIdentity else {
            return .identity
        }
        return CGAffineTransform.anchoredScale(
            anchor: location,
            zoomedContentOrigin: CXZoomGesture.makeZoomedContentOrigin(
                content: contentSize,
                screen: config.availableSize
            ),
            contentSize: contentSize,
            screenSize: config.availableSize,
            scale: CXZoomGesture.makeZoomScale(content: contentSize, screen: config.availableSize)
        )
    }

    /// Creates transform for magnification gesture end state
    private func makeMagnifyEndTransform(anchor: CGPoint) -> CGAffineTransform {
        let scale = transform.scaleX
        guard scale > 1.0 else {
            return .identity
        }

        if scale >= maxZoomScale {
            return CGAffineTransform.anchoredScale(scale: maxZoomScale, anchor: anchor)
        }

        return transform
    }

    /// Calculates the origin point for zoomed content
    private static func makeZoomedContentOrigin(content: CGSize, screen: CGSize) -> CGPoint {
        CGPoint(
            x: (content.width - screen.width) / 2,
            y: (content.height - screen.height) / 2
        )
    }

    /// Calculates appropriate zoom scale based on content and screen size
    private static func makeZoomScale(content: CGSize, screen: CGSize) -> CGFloat {
        max(screen.width / content.width, screen.height / content.height)
    }

    /// Updates maximum zoom scale based on content and screen size
    private static func updateMaxZoomScale(
        content: CGSize,
        screen: CGSize,
        maxZoomScale: CGFloat
    ) -> CGFloat {
        max(maxZoomScale, makeZoomScale(content: content, screen: screen))
    }
}

// MARK: - Extensions

public extension View {
    /// Adds zoom gesture support to a view.
    /// - Parameters:
    ///   - config: Configuration for the zoom gesture behavior.
    ///   - isZoomIn: Binding to track zoom state.
    /// - Returns: A view with zoom gesture support.
    @available(iOS 17.0, *)
    func zoomGesture(config: CXZoomGesture.Config, isZoomIn: Binding<Bool>, onDoubleTap: CXNoArgumentAction? = nil) -> some View {
        modifier(CXZoomGesture(config: config, isZoomIn: isZoomIn, onDoubleTap: onDoubleTap))
    }
}
