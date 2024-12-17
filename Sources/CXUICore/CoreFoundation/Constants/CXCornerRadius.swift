//
//  CXCornerRadius.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/16/24.
//

import CoreFoundation

/// A collection of standardized corner radius values for UI elements.
/// These values are based on the CXSpace scale to maintain consistency across the UI.
public enum CXCornerRadius {
    /// Small corner radius (8pt) - suitable for compact UI elements
    public static let small = CXSpacing.oneX

    /// Medium corner radius (16pt) - suitable for standard UI elements
    public static let medium = CXSpacing.twoX

    /// Large corner radius (24pt) - suitable for prominent UI elements
    public static let large = CXSpacing.threeX

    /// Extra large corner radius (32pt) - suitable for modal views and cards
    public static let extraLarge = CXSpacing.fourX

    /// Extra extra large corner radius (40pt) - suitable for full-screen modals
    public static let extraExtraLarge = CXSpacing.fiveX
}
