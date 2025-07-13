//
//  View+AnyView.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 7/13/25.
//

import SwiftUI

public extension View {
    
    /// Converts the view to an `AnyView`, erasing its specific type.
    var erased: AnyView {
        AnyView(self)
    }
}
