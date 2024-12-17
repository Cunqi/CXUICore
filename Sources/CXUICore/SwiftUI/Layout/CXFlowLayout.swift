//
//  CXFlowLayout.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

/// A layout container that arranges its child views in a flowing manner, similar to text wrapping.
/// The views are arranged horizontally until they reach the container's width, then continue on the next line.
@available(iOS 16.0, *)
public struct CXFlowLayout: Layout {
    /// Configuration options for the flow layout behavior.
    public struct Config {
        /// The horizontal spacing between items.
        var horizontalSpacing: CGFloat

        /// The vertical spacing between rows.
        var verticalSpacing: CGFloat

        /// The alignment of items within their row.
        var alignment: HorizontalAlignment

        /// Creates a new flow layout configuration.
        /// - Parameters:
        ///   - horizontalSpacing: Spacing between items horizontally (default: 8)
        ///   - verticalSpacing: Spacing between rows vertically (default: 8)
        ///   - alignment: Horizontal alignment of items in rows (default: .leading)
        public init(horizontalSpacing: CGFloat = CXSpacing.oneX,
                    verticalSpacing: CGFloat = CXSpacing.oneX,
                    alignment: HorizontalAlignment = .leading)
        {
            self.horizontalSpacing = horizontalSpacing
            self.verticalSpacing = verticalSpacing
            self.alignment = alignment
        }
    }

    /// The configuration for the flow layout behavior.
    private let config: Config

    /// Creates a new flow layout with the specified configuration.
    /// - Parameter config: The configuration for the flow layout
    public init(config: Config = .init()) {
        self.config = config
    }

    public func sizeThatFits(proposal: ProposedViewSize,
                             subviews: Subviews,
                             cache _: inout Void) -> CGSize
    {
        guard !subviews.isEmpty else { return .zero }

        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        var height: CGFloat = 0

        for (index, row) in rows.enumerated() {
            let rowHeight = row.map { $0.sizeThatFits(proposal).height }.max() ?? 0
            if index > 0 {
                height += config.verticalSpacing
            }
            height += rowHeight
        }

        return CGSize(width: proposal.width ?? 0, height: height)
    }

    public func placeSubviews(in bounds: CGRect,
                              proposal: ProposedViewSize,
                              subviews: Subviews,
                              cache _: inout Void)
    {
        guard !subviews.isEmpty else { return }

        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        var y = bounds.minY

        for row in rows {
            let rowHeight = row.map { $0.sizeThatFits(proposal).height }.max() ?? 0
            let rowWidth = row.map { $0.sizeThatFits(proposal).width }.reduce(0) { $0 + config.horizontalSpacing + $1 } - config.horizontalSpacing

            var x: CGFloat
            switch config.alignment {
            case .leading:
                x = bounds.minX
            case .center:
                x = bounds.minX + (bounds.width - rowWidth) / 2
            case .trailing:
                x = bounds.maxX - rowWidth
            default:
                x = bounds.minX
            }

            for subview in row {
                let size = subview.sizeThatFits(proposal)
                subview.place(at: CGPoint(x: x, y: y + (rowHeight - size.height) / 2),
                              anchor: .topLeading,
                              proposal: proposal)
                x += size.width + config.horizontalSpacing
            }

            y += rowHeight + config.verticalSpacing
        }
    }

    /// Arranges subviews into rows based on available width.
    /// - Parameters:
    ///   - proposal: The proposed size for layout
    ///   - subviews: The subviews to arrange
    /// - Returns: An array of arrays, where each inner array represents a row of views
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var currentRow = 0
        var remainingWidth = proposal.width ?? 0

        for subview in subviews {
            let size = subview.sizeThatFits(proposal)

            if currentRow == 0 || size.width <= remainingWidth {
                rows[currentRow].append(subview)
                remainingWidth -= size.width + config.horizontalSpacing
            } else {
                currentRow += 1
                rows.append([subview])
                remainingWidth = (proposal.width ?? 0) - size.width - config.horizontalSpacing
            }
        }

        return rows
    }
}
