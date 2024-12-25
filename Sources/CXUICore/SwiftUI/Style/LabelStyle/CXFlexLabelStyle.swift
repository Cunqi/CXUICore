//
//  CXFlexLabelStyle.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

/// A flexible label style that allows customization of icon visibility, position, and spacing.
/// This style provides options to show/hide the icon, position it before or after the title,
/// and control the spacing between components.
///
/// Example usage:
/// ```swift
/// Label("Settings", systemImage: "gear")
///     .labelStyle(.flex(
///         isIconVisible: true,
///         iconPosition: .leading,
///         spacing: CXSpacing.halfX
///     ))
/// ```
public struct CXFlexLabelStyle: LabelStyle {
    /// Defines the position of the icon relative to the title text.
    public enum IconPosition {
        /// Places the icon before the title
        case leading
        /// Places the icon after the title
        case trailing
    }

    /// Determines whether the icon is visible in the label.
    let isIconVisible: Bool

    /// Determines whether the title is visible in the label.
    let isTitleVisible: Bool

    /// The position of the icon relative to the title.
    let iconPosition: IconPosition

    /// The spacing between the icon and title.
    /// Uses CXSpacing constants for consistent spacing across the app.
    let spacing: CGFloat

    /// Creates the body view for the label style.
    /// Arranges the icon and title in a horizontal stack with the specified configuration.
    /// - Parameter configuration: The label configuration containing the icon and title views
    /// - Returns: A view containing the arranged label components
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            if isIconVisible, iconPosition == .leading {
                configuration.icon
                    .transition(.move(edge: .leading))
            }
            if isTitleVisible {
                configuration.title
                    .transition(.opacity)
            }
            if isIconVisible, iconPosition == .trailing {
                configuration.icon
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

public extension LabelStyle where Self == CXFlexLabelStyle {
    /// Creates a flexible label style with customizable icon visibility, position, and spacing.
    /// - Parameters:
    ///   - isIconVisible: Whether to show the icon (default: true)
    ///   - iconPosition: Position of the icon relative to title (default: .leading)
    ///   - spacing: Space between icon and title (default: CXSpacing.halfX)
    /// - Returns: A configured CXFlexLabelStyle instance
    static func flex(isIconVisible: Bool = true,
                     isTitleVisible: Bool = true,
                     iconPosition: CXFlexLabelStyle.IconPosition = .leading,
                     spacing: CGFloat = CXSpacing.halfX) -> CXFlexLabelStyle
    {
        CXFlexLabelStyle(
            isIconVisible: isIconVisible,
            isTitleVisible: isTitleVisible,
            iconPosition: iconPosition,
            spacing: spacing
        )
    }
}
