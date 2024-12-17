//
//  CXSwipeGesture.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

/// A SwiftUI view modifier that adds customizable swipe gesture functionality to any view.
/// This gesture supports both horizontal and vertical swipes with configurable thresholds and visual feedback.
public struct CXSwipeGesture: ViewModifier {
    /// Configuration options for the swipe gesture behavior.
    public struct Config {
        /// The maximum distance in points that a horizontal swipe can travel.
        var maxHorizontalSwipeDistance: CGFloat

        /// The maximum distance in points that a vertical swipe can travel.
        var maxVerticalSwipeDistance: CGFloat

        /// The minimum distance in points required to recognize a horizontal swipe.
        var minHorizontalSwipeDistance: CGFloat

        /// The minimum distance in points required to recognize a vertical swipe.
        var minVerticalSwipeDistance: CGFloat

        /// The minimum opacity value during the swipe animation.
        var minOpacity: CGFloat

        /// The scale factor applied to the swipe translation for visual feedback.
        var swipeScale: CGFloat

        /// Whether the swipe gesture is disabled.
        var isDisabled: Bool

        /// Creates a new swipe gesture configuration.
        /// - Parameters:
        ///   - maxHorizontalSwipeDistance: Maximum horizontal swipe distance (default: 150)
        ///   - maxVerticalSwipeDistance: Maximum vertical swipe distance (default: 100)
        ///   - minHorizontalSwipeDistance: Minimum horizontal swipe distance (default: 50)
        ///   - minVerticalSwipeDistance: Minimum vertical swipe distance (default: 50)
        ///   - minOpacity: Minimum opacity during swipe (default: 0.9)
        ///   - swipeScale: Scale factor for swipe translation (default: 0.7)
        ///   - isDisabled: Whether the gesture is disabled (default: false)
        public init(maxHorizontalSwipeDistance: CGFloat = 150,
                    maxVerticalSwipeDistance: CGFloat = 100,
                    minHorizontalSwipeDistance: CGFloat = 50,
                    minVerticalSwipeDistance: CGFloat = 50,
                    minOpacity: CGFloat = 0.9,
                    swipeScale: CGFloat = 0.7,
                    isDisabled: Bool = false)
        {
            self.maxHorizontalSwipeDistance = maxHorizontalSwipeDistance
            self.maxVerticalSwipeDistance = maxVerticalSwipeDistance
            self.minHorizontalSwipeDistance = minHorizontalSwipeDistance
            self.minVerticalSwipeDistance = minVerticalSwipeDistance
            self.minOpacity = minOpacity
            self.swipeScale = swipeScale
            self.isDisabled = isDisabled
        }
    }

    // MARK: - Internal properties

    /// The configuration for the swipe gesture behavior.
    var config: Config

    /// The current translation of the view during the swipe.
    @Binding var translation: CGSize
    /// The current opacity of the view during the swipe.
    @Binding var opacity: CGFloat
    /// The predicted direction of the swipe based on the current gesture.
    @Binding var predictedDirection: CXSwipeDirection

    /// Callback triggered when a swipe gesture is completed.
    var onSwipe: (CXSwipeDirection) -> Void

    // MARK: - Private properties

    /// The locked direction once a swipe gesture starts.
    @State private var lockedDirection: CXSwipeDirection = .none
    /// The locked vertical position for horizontal swipes.
    @State private var lockedYPosition: CGFloat = .zero
    /// The latest drag gesture value for tracking the gesture state.
    @State private var latestDragGestureValue: DragGesture.Value?
    /// Whether the view is currently being dragged.
    @GestureState private var isDragging = false

    /// Generator for determining swipe directions based on gesture translations.
    private var swipeDirectionGenerator: CXSwipeDirection.Generator

    // MARK: - Initializers

    /// Creates a new swipe gesture modifier.
    /// - Parameters:
    ///   - config: The configuration for the swipe gesture
    ///   - translation: Binding to the view's translation
    ///   - opacity: Binding to the view's opacity
    ///   - predictedDirection: Binding to the predicted swipe direction
    ///   - onSwipe: Callback triggered when a swipe is completed
    public init(config: Config = .init(),
                translation: Binding<CGSize>,
                opacity: Binding<CGFloat>,
                predictedDirection: Binding<CXSwipeDirection>,
                onSwipe: @escaping (CXSwipeDirection) -> Void)
    {
        self.config = config
        swipeDirectionGenerator = CXSwipeDirection.Generator(
            maxHorizontalSwipeDistance: config.maxHorizontalSwipeDistance,
            maxVerticalSwipeDistance: config.maxVerticalSwipeDistance,
            minHorizontalSwipeDistance: config.minHorizontalSwipeDistance,
            minVerticalSwipeDistance: config.minVerticalSwipeDistance
        )

        _translation = translation
        _opacity = opacity
        _predictedDirection = predictedDirection

        self.onSwipe = onSwipe
    }

    public func body(content: Content) -> some View {
        content.highPriorityGesture(
            DragGesture(
                minimumDistance: 0
            )
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { gesture in
                latestDragGestureValue = gesture

                let translation = gesture.translation

                if lockedDirection == .none {
                    lockedDirection = swipeDirectionGenerator.direction(for: translation)
                    predictedDirection = lockedDirection
                    lockedYPosition = translation.height
                }

                switch lockedDirection {
                case .left, .right:
                    self.translation = CGSize(width: translation.width * config.swipeScale, height: lockedYPosition)
                    self.opacity = translation.width.magnitude * config.swipeScale / config.maxHorizontalSwipeDistance
                case .up, .down:
                    self.translation = CGSize(width: .zero, height: translation.height * config.swipeScale)
                    self.opacity = max(config.minOpacity, 1.0 - translation.height.magnitude * config.swipeScale / config.maxVerticalSwipeDistance)
                case .none:
                    self.translation = translation
                    self.opacity = 1.0
                }
            }
            .onEnded { _ in
                let decidedDirection = swipeDirectionGenerator.endDirection(for: lockedDirection, translation: translation * config.swipeScale)
                withAnimation {
                    onSwipe(decidedDirection)
                    reset()
                }
            },
            including: config.isDisabled ? .subviews : .gesture
        )
        .onChange(of: isDragging) { isDragging in
            if !isDragging && latestDragGestureValue != nil {
                withAnimation {
                    reset()
                }
            }
        }
    }

    // MARK: - Private methods

    /// Resets the gesture state to its initial values.
    private func reset() {
        predictedDirection = .none
        lockedDirection = .none
        lockedYPosition = .zero
        latestDragGestureValue = nil
        translation = .zero
        opacity = 1.0
    }
}

// MARK: - Extensions

public extension View {
    /// Adds a customizable swipe gesture to the view.
    /// - Parameters:
    ///   - config: Configuration for the swipe gesture behavior
    ///   - translation: Binding to track the view's translation during the swipe
    ///   - opacity: Binding to track the view's opacity during the swipe
    ///   - predictedDirection: Binding to track the predicted swipe direction
    ///   - onSwipe: Callback triggered when a swipe is completed
    /// - Returns: A view with the swipe gesture modifier applied
    func swipeGesture(config: CXSwipeGesture.Config = .init(),
                      translation: Binding<CGSize>,
                      opacity: Binding<CGFloat> = .constant(1.0),
                      predictedDirection: Binding<CXSwipeDirection>,
                      onSwipe: @escaping (CXSwipeDirection) -> Void) -> some View
    {
        modifier(CXSwipeGesture(
            config: config,
            translation: translation,
            opacity: opacity,
            predictedDirection: predictedDirection,
            onSwipe: onSwipe
        ))
    }
}
