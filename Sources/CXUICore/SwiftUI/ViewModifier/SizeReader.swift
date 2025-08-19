//
//  SizeReader.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 8/18/25.
//

import SwiftUI

/// 用来保存尺寸的 PreferenceKey
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize {
        .zero
    }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let nextValue = nextValue()
        if nextValue != .zero {
            // 只更新非零尺寸
            value = nextValue
        }
    }
}

/// 一个 ViewModifier，可以把子视图的尺寸读出来
struct SizeReader: ViewModifier {
    let onChange: (CGSize) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self,
                                    value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

extension View {
    public func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        self.modifier(SizeReader(onChange: onChange))
    }
}
