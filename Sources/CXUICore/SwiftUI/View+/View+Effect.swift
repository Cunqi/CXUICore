//
//  View+Effect.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

extension View {
    
    func zoomTransformEffect(_ transform: CGAffineTransform) -> some View {
        scaleEffect(
            x: transform.scaleX,
            y: transform.scaleY,
            anchor: .zero
        )
        .offset(x: transform.tx, y: transform.ty)
    }
    
}
