//
//  CGSize+.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import CoreFoundation

/// Extension providing additional functionality for CGSize
public extension CGSize {
    // MARK: - Initializers

    /// Creates a CGSize with equal width and height, forming a square size.
    /// - Parameter square: The length to use for both width and height
    init(square: CGFloat) {
        self.init(width: square, height: square)
    }

    // MARK: - Properties

    /// The area of the size (width * height).
    var area: CGFloat {
        width * height
    }

    /// The width to height ratio.
    var whRatio: CGFloat {
        width / height
    }

    /// The height to width ratio.
    var hwRatio: CGFloat {
        height / width
    }

    /// The shortest edge of the size.
    var shortestEdge: CGFloat {
        min(width, height)
    }

    /// The longest edge of the size.
    var longestEdge: CGFloat {
        max(width, height)
    }

    /// The magnitude (length) of the size when treated as a vector.
    /// Calculated as the square root of (width² + height²).
    var magnitude: CGFloat {
        sqrt(width * width + height * height)
    }

    /// Returns true if both width and height are zero.
    var isZero: Bool {
        width == .zero && height == .zero
    }

    // MARK: - Methods

    /// Returns a new size that represents the union of this size and another size.
    /// - Parameter other: The other size to union with
    /// - Returns: A new size with the maximum width and height of both sizes
    func union(_ other: CGSize) -> CGSize {
        CGSize(width: max(width, other.width), height: max(height, other.height))
    }

    /// Returns a new size that represents the intersection of this size and another size.
    /// - Parameter other: The other size to intersect with
    /// - Returns: A new size with the minimum width and height of both sizes
    func intersection(_ other: CGSize) -> CGSize {
        CGSize(width: min(width, other.width), height: min(height, other.height))
    }

    // MARK: - Binary Operators

    /// Adds two CGSize values.
    /// - Parameters:
    ///   - lhs: The first CGSize
    ///   - rhs: The second CGSize
    /// - Returns: A new CGSize with summed width and height
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    /// Subtracts two CGSize values.
    /// - Parameters:
    ///   - lhs: The CGSize to subtract from
    ///   - rhs: The CGSize to subtract
    /// - Returns: A new CGSize with subtracted width and height
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    /// Multiplies two CGSize values component-wise.
    /// - Parameters:
    ///   - lhs: The first CGSize
    ///   - rhs: The second CGSize
    /// - Returns: A new CGSize with multiplied width and height
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    /// Multiplies a CGSize by a scalar value.
    /// - Parameters:
    ///   - lhs: The CGSize to multiply
    ///   - rhs: The scalar value to multiply by
    /// - Returns: A new CGSize with scaled width and height
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }

    /// Divides two CGSize values component-wise.
    /// - Parameters:
    ///   - lhs: The CGSize to divide
    ///   - rhs: The CGSize to divide by
    /// - Returns: A new CGSize with divided width and height
    static func / (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
    }

    /// Divides a CGSize by a scalar value.
    /// - Parameters:
    ///   - lhs: The CGSize to divide
    ///   - rhs: The scalar value to divide by
    /// - Returns: A new CGSize with divided width and height
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    }

    // MARK: - Compound Assignment Operators

    /// Adds another CGSize to this size in place.
    /// - Parameter rhs: The CGSize to add
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }

    /// Subtracts another CGSize from this size in place.
    /// - Parameter rhs: The CGSize to subtract
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs - rhs
    }

    /// Multiplies this size by a scalar value in place.
    /// - Parameter scalar: The scalar value to multiply by
    static func *= (size: inout CGSize, scalar: CGFloat) {
        size = size * scalar
    }

    /// Divides this size by a scalar value in place.
    /// - Parameter scalar: The scalar value to divide by
    static func /= (size: inout CGSize, scalar: CGFloat) {
        size = size / scalar
    }
}
