//
//  CXBadge.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

public struct CXBadge<Badge: View>: ViewModifier {
    // MARK: - Internal properties

    var badge: Badge

    var isVisible: Bool

    var onTap: CXNoArgumentAction?

    // MARK: - Initializers

    public init(@ViewBuilder badge: () -> Badge, isVisible: Bool = true, onTap: CXNoArgumentAction? = nil) {
        self.badge = badge()
        self.isVisible = isVisible
        self.onTap = onTap
    }

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                Group {
                    if isVisible {
                        badge
                    }
                }
                .alignmentGuide(.top) { @Sendable dimension in
                    dimension[.top] + dimension.height / 3
                }
                .alignmentGuide(.trailing) { @Sendable dimension in
                    dimension[.trailing] - dimension.width / 3
                }
            }
            .contentShape(.rect)
            .onTapGesture {
                onTap?()
            }
    }
}

public extension View {
    func badge<Badge: View>(isVisible: Bool,
                            @ViewBuilder badge: () -> Badge,
                            onTap: CXNoArgumentAction? = nil) -> some View {
        modifier(CXBadge(badge: badge, isVisible: isVisible, onTap: onTap))
    }
}

#Preview {
    Rectangle()
        .fill(Color.red)
        .frame(square: 90)
        .badge(isVisible: true) {
            Text("1")
                .padding()
                .background(.blue)
                .clipShape(.capsule)
        }
}
