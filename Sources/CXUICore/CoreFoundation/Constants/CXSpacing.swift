//
//  CXSpacing.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/16/24.
//

import CoreFoundation

/// A collection of standardized spacing constants used throughout the UI.
/// All values are in points and follow a base-8 scale with some additional intermediate values.
public enum CXSpacing {
    /// Represents 2pt spacing (1/4 of base unit)
    public static let quarterX: CGFloat = 2

    /// Represents 4pt spacing (1/2 of base unit)
    public static let halfX: CGFloat = 4

    /// Represents 8pt spacing (base unit)
    public static let oneX: CGFloat = 8

    /// Represents 12pt spacing (1.5x base unit)
    public static let oneAndHalfX: CGFloat = 12

    /// Represents 16pt spacing (2x base unit)
    public static let twoX: CGFloat = 16

    /// Represents 24pt spacing (3x base unit)
    public static let threeX: CGFloat = 24

    /// Represents 32pt spacing (4x base unit)
    public static let fourX: CGFloat = 32

    /// Represents 40pt spacing (5x base unit)
    public static let fiveX: CGFloat = 40

    /// Represents 48pt spacing (6x base unit)
    public static let sixX: CGFloat = 48

    /// Represents 56pt spacing (7x base unit)
    public static let sevenX: CGFloat = 56

    /// Represents 64pt spacing (8x base unit)
    public static let eightX: CGFloat = 64

    /// Represents 72pt spacing (9x base unit)
    public static let nineX: CGFloat = 72

    /// Represents 80pt spacing (10x base unit)
    public static let tenX: CGFloat = 80

    /// Represents 88pt spacing (11x base unit)
    public static let elevenX: CGFloat = 88

    /// Represents 96pt spacing (12x base unit)
    public static let twelveX: CGFloat = 96
}
