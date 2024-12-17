//
//  View+Frame.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/16/24.
//

import SwiftUI

/// Extension providing convenient frame modifiers for SwiftUI Views
public extension View {
    /// Sets both the width and height of the view using a CGSize.
    /// - Parameters:
    ///   - size: The size (width and height) to apply to the view
    ///   - alignment: The alignment of the view within its frame (default: .center)
    /// - Returns: A view with the specified frame size
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height, alignment: alignment)
    }

    /// Sets both the width and height of the view to the same value, creating a square frame.
    /// - Parameters:
    ///   - square: The length of both sides of the square frame
    ///   - alignment: The alignment of the view within its frame (default: .center)
    /// - Returns: A view with a square frame of the specified size
    func frame(square: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: square, height: square, alignment: alignment)
    }
}
