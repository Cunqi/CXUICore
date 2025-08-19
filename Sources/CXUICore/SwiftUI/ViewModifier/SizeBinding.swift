//
//  SizeBinding.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 8/18/25.
//

import SwiftUI

// 一个 ViewModifier，可以把子视图的尺寸读出来
struct SizeBinding: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self,
                                    value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) {
                size = $0
            }
    }
}

extension View {
    public func bindSize(size: Binding<CGSize>) -> some View {
        self.modifier(SizeBinding(size: size))
    }
}
