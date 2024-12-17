//
//  CGAffineTransform+.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import CoreGraphics

/// Extension providing convenient methods for creating and manipulating affine transforms
/// with support for anchored transformations commonly used in gesture handling.
extension CGAffineTransform {
    /// Creates a transform that scales around a specific anchor point.
    /// - Parameters:
    ///   - scale: The scale factor to apply
    ///   - anchor: The point around which to perform the scaling
    /// - Returns: A new transform representing the anchored scale
    static func anchoredScale(scale: CGFloat, anchor: CGPoint) -> CGAffineTransform {
        .init(translationX: anchor.x, y: anchor.y)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -anchor.x, y: -anchor.y)
    }

    /// Creates a transform that scales around an anchor point with additional positioning constraints.
    /// - Parameters:
    ///   - anchor: The point around which to perform the scaling
    ///   - zoomedContentOrigin: The origin point of the zoomed content
    ///   - contentSize: The size of the content being transformed
    ///   - screenSize: The size of the screen or container
    ///   - scale: The scale factor to apply
    /// - Returns: A new transform representing the constrained anchored scale
    static func anchoredScale(
        anchor: CGPoint,
        zoomedContentOrigin: CGPoint,
        contentSize: CGSize,
        screenSize: CGSize,
        scale: CGFloat
    ) -> CGAffineTransform {
        // position to top-left
        let contentXRatio = anchor.x / contentSize.width
        let contentYRatio = anchor.y / contentSize.height

        // scaled content size
        let zoomedSize = contentSize * scale

        // tap position in scaled content
        let zoomedAnchor = CGPoint(x: contentXRatio * zoomedSize.width + zoomedContentOrigin.x, y: contentYRatio * zoomedSize.height + zoomedContentOrigin.y)

        // scaled offset
        let offsetX = min(max(zoomedAnchor.x - screenSize.width / 2.0, 0), zoomedSize.width - screenSize.width)
        let offsetY = min(max(zoomedAnchor.y - screenSize.height / 2.0, 0), zoomedSize.height - screenSize.height)

        return CGAffineTransform(translationX: zoomedContentOrigin.x, y: zoomedContentOrigin.y)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -offsetX / scale, y: -offsetY / scale)
    }

    /// The horizontal scale factor of the transform.
    var scaleX: CGFloat {
        sqrt(a * a + c * c)
    }

    /// The vertical scale factor of the transform.
    var scaleY: CGFloat {
        sqrt(b * b + d * d)
    }
}
