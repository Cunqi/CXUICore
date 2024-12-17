//
//  CXSwipeDirection.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/16/24.
//

import SwiftUI

/// Represents the possible directions for a swipe gesture.
/// This enum provides a type-safe way to specify and handle swipe directions in SwiftUI views.
public enum CXSwipeDirection: Int, CaseIterable, Sendable {
    /// Represents a swipe from top to bottom
    case up
    /// Represents a swipe from bottom to top
    case down
    /// Represents a swipe from left to right
    case left
    /// Represents a swipe from right to left
    case right
    /// Represents no swipe direction
    case none

    /// Returns the opposite direction of the current swipe
    public var opposite: CXSwipeDirection {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        case .none:
            return .none
        }
    }

    /// Returns true if the swipe direction is horizontal (left or right)
    public var isHorizontal: Bool {
        switch self {
        case .left, .right:
            return true
        case .up, .down, .none:
            return false
        }
    }

    /// Returns true if the swipe direction is vertical (up or down)
    public var isVertical: Bool {
        switch self {
        case .up, .down:
            return true
        case .left, .right, .none:
            return false
        }
    }

    /// Returns the axis (horizontal or vertical) for the swipe direction
    public var axis: Axis {
        isHorizontal ? .horizontal : .vertical
    }
}

// MARK: - Generator

public extension CXSwipeDirection {
    /// A utility struct that generates and validates swipe directions based on gesture translations.
    /// This struct provides configurable thresholds for both horizontal and vertical swipes.
    struct Generator {
        // MARK: - trigger thresholds

        /// The maximum distance in points that a horizontal swipe can travel before being recognized as a complete swipe.
        public let maxHorizontalSwipeDistance: CGFloat

        /// The maximum distance in points that a vertical swipe can travel before being recognized as a complete swipe.
        public let maxVerticalSwipeDistance: CGFloat

        /// The minimum distance in points that a horizontal swipe must travel to be recognized as a swipe gesture.
        public let minHorizontalSwipeDistance: CGFloat

        /// The minimum distance in points that a vertical swipe must travel to be recognized as a swipe gesture.
        public let minVerticalSwipeDistance: CGFloat

        // MARK: - Initializers

        /// Creates a new swipe direction generator with customizable threshold values.
        /// - Parameters:
        ///   - maxHorizontalSwipeDistance: Maximum distance for horizontal swipes (default: 150 points)
        ///   - maxVerticalSwipeDistance: Maximum distance for vertical swipes (default: 100 points)
        ///   - minHorizontalSwipeDistance: Minimum distance for horizontal swipes (default: 50 points)
        ///   - minVerticalSwipeDistance: Minimum distance for vertical swipes (default: 50 points)
        public init(maxHorizontalSwipeDistance: CGFloat = 150,
                    maxVerticalSwipeDistance: CGFloat = 100,
                    minHorizontalSwipeDistance: CGFloat = 50,
                    minVerticalSwipeDistance: CGFloat = 50)
        {
            self.maxHorizontalSwipeDistance = maxHorizontalSwipeDistance
            self.maxVerticalSwipeDistance = maxVerticalSwipeDistance
            self.minHorizontalSwipeDistance = minHorizontalSwipeDistance
            self.minVerticalSwipeDistance = minVerticalSwipeDistance
        }

        // MARK: - Public methods

        /// Determines the swipe direction based on the current gesture translation.
        /// - Parameter translation: The current translation of the gesture
        /// - Returns: The detected swipe direction, or `.none` if no valid swipe is detected
        public func direction(for translation: CGSize) -> CXSwipeDirection {
            switch translation {
            case let translation where translation.width < -minHorizontalSwipeDistance && isValidForHorizontalSwipe(translation):
                return .left
            case let translation where translation.width > minHorizontalSwipeDistance && isValidForHorizontalSwipe(translation):
                return .right
            case let translation where translation.height < -minVerticalSwipeDistance && isValidForVerticalSwipe(translation):
                return .up
            case let translation where translation.height > minVerticalSwipeDistance && isValidForVerticalSwipe(translation):
                return .down
            default:
                return .none
            }
        }

        /// Determines if a swipe gesture should be considered complete based on the current direction and translation.
        /// - Parameters:
        ///   - direction: The current swipe direction
        ///   - translation: The current translation of the gesture
        /// - Returns: The final swipe direction if the gesture is complete, or `.none` if the gesture should be canceled
        public func endDirection(for direction: CXSwipeDirection, translation: CGSize) -> CXSwipeDirection {
            switch direction {
            case .left:
                return translation.width < -maxHorizontalSwipeDistance ? .left : .none
            case .right:
                return translation.width > maxHorizontalSwipeDistance ? .right : .none
            case .up:
                return translation.height < -maxVerticalSwipeDistance ? .up : .none
            case .down:
                return translation.height > maxVerticalSwipeDistance ? .down : .none
            case .none:
                return .none
            }
        }

        // MARK: - Private methods

        /// Checks if the translation is valid for a horizontal swipe by ensuring vertical movement is minimal.
        /// - Parameter translation: The current translation of the gesture
        /// - Returns: `true` if the translation is valid for a horizontal swipe
        private func isValidForHorizontalSwipe(_ translation: CGSize) -> Bool {
            translation.height.magnitude <= minVerticalSwipeDistance
        }

        /// Checks if the translation is valid for a vertical swipe by ensuring horizontal movement is minimal.
        /// - Parameter translation: The current translation of the gesture
        /// - Returns: `true` if the translation is valid for a vertical swipe
        private func isValidForVerticalSwipe(_ translation: CGSize) -> Bool {
            translation.width.magnitude <= minHorizontalSwipeDistance
        }
    }
}
