//
//  View+Background.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

/// Provides convenient extensions for applying background styling to SwiftUI views.
/// These methods offer a consistent way to apply background colors and materials across your app.
public extension View {
    /// Applies a background to the view using either a color or material.
    /// - Parameters:
    ///   - color: Optional color to use as the background. If nil and material is nil, no background is applied.
    ///   - material: Optional material to use as the background. If nil and color is nil, no background is applied.
    /// - Returns: A view with the specified background styling applied.
    @ViewBuilder
    func background(color: Color? = nil, material: Material? = nil) -> some View {
        if let color {
            background(color)
        } else if let material {
            background(material)
        }
    }
}
