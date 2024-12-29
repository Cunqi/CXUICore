//
//  CXCarouselView.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/27/24.
//

import SwiftUI

public struct CXCarouselView<CarouselItemContent: View>: View {
    // MARK: - Constants

    private static var carouselItemCount: Int { 3 }

    // MARK: - Internal properties

    @ViewBuilder var itemContent: (Int, Int) -> CarouselItemContent

    // MARK: - Private properties

    @State private var currentIndex = 0

    @State private var width: CGFloat = .zero

    @State private var offset: CGFloat = .zero

    @State private var latestDragGestureValue: DragGesture.Value?

    @State private var itemOffset: Int = 0

    @State private var parentOffsetX: CGFloat = .zero

    @State private var isForward = false

    @GestureState private var isDragging = false

    // MARK: - Initializers

    public init(@ViewBuilder itemContent: @escaping (Int, Int) -> CarouselItemContent) {
        self.itemContent = itemContent
    }

    // MARK: - Views

    public var body: some View {
        ZStack {
            ForEach(0 ..< 3) { index in
                CXCarouselItemView(
                    currentIndex: currentIndex,
                    index: index,
                    itemOffset: itemOffset,
                    isForward: isForward,
                    itemContent: itemContent
                )
                .offset(x: offset(at: index))
                .environment(\.parentOffsetX, parentOffsetX)
            }
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.width
        } action: { newValue in
            width = newValue
        }
        .gesture(
            DragGesture(coordinateSpace: .global)
                .updating($isDragging) { _, state, _ in
                    state = true
                }
                .onChanged { value in
                    latestDragGestureValue = value
                    isForward = value.translation.width < 0
                    withAnimation(.interactiveSpring(duration: 0.15)) {
                        offset = value.translation.width
                    }
                }
                .onEnded { value in
                    let threshold = width / CGFloat(CXCarouselView.carouselItemCount)
                    var newCurrentIndex = currentIndex
                    var newItemOffset = itemOffset

                    if value.translation.width < -threshold {
                        newCurrentIndex = (currentIndex + 1) % CXCarouselView.carouselItemCount
                        newItemOffset += 1
                    } else if value.translation.width > threshold {
                        newCurrentIndex = (currentIndex - 1 + CXCarouselView.carouselItemCount) % CXCarouselView.carouselItemCount
                        newItemOffset -= 1
                    } else {
                        isForward = !isForward
                    }

                    withAnimation(.snappy) {
                        offset = 0
                        self.currentIndex = newCurrentIndex
                        self.itemOffset = newItemOffset
                    }
                }
        )
        .onChange(of: isDragging) { _, isDragging in
            if !isDragging && latestDragGestureValue != nil {
                withAnimation {
                    offset = 0
                }
            }
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.frame(in: .global).minX
        } action: { newValue in
            parentOffsetX = newValue
        }
    }

    // MARK: - Private methods

    private func offset(at index: Int) -> CGFloat {
        indexOffset(for: index) * width + offset
    }

    private func indexOffset(for index: Int) -> CGFloat {
        guard index != currentIndex else {
            return 0
        }

        switch index {
        case 0:
            return currentIndex == 1 ? -1 : 1
        case 1:
            return currentIndex == 2 ? -1 : 1
        case 2:
            return currentIndex == 0 ? -1 : 1
        default:
            return 0
        }
    }
}

struct CXCarouselItemView<ItemContent: View>: View {

    var currentIndex: Int

    var index: Int

    var itemOffset: Int

    var isForward: Bool

    @ViewBuilder var itemContent: (Int, Int) -> ItemContent

    @State private var offsetX = CGFloat.zero
    @State private var width: CGFloat = 0

    @Environment(\.parentOffsetX) private var parentOffsetX

    var body: some View {
        itemContent(index, getTargetOffset())
            .onGeometryChange(for: CGRect.self, of: { proxy in
                proxy.frame(in: .global)
            }, action: { newValue in
                width = newValue.width

                guard index != currentIndex else {
                    withAnimation {
                        offsetX = newValue.minX
                    }
                    return
                }

                var isAnimated = false

                if currentIndex == 0 {
                    isAnimated = index == 2 && isForward || index == 1 && !isForward
                } else if currentIndex == 1 {
                    isAnimated = index == 0 && isForward || index == 2 && !isForward
                } else {
                    isAnimated = index == 1 && isForward || index == 0 && !isForward
                }

                withAnimation(isAnimated ? .default : nil) {
                    offsetX = newValue.minX
                }

            })
            .opacity(offsetX <= -(width - parentOffsetX.magnitude) || offsetX >= (width - parentOffsetX.magnitude) ? 0 : 1)
    }

    private func getTargetOffset() -> Int {
        guard currentIndex != index else {
            return itemOffset
        }

        switch currentIndex {
        case 0:
            return index == 1 ? itemOffset + 1 : itemOffset - 1
        case 1:
            return index == 0 ? itemOffset - 1 : itemOffset + 1
        case 2:
            return index == 0 ? itemOffset + 1 : itemOffset - 1
        default:
            return itemOffset
        }
    }
}

extension EnvironmentValues {
    @Entry var parentOffsetX: CGFloat = .zero
}
