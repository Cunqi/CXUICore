//
//  CXTagButton.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import CXFoundation
import SwiftUI

public struct CXTagButton: View {
    public struct Config {
        public var title: String
        public var systemImage: String?
        public var foregroundColor: Color
        public var backgroundColor: Color
        public var preseedColor: Color?

        public init(title: String,
                    systemImage: String? = nil,
                    foregroundColor: Color = .primary,
                    backgroundColor: Color = .systemGray,
                    preseedColor: Color? = nil)
        {
            self.title = title
            self.systemImage = systemImage
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.preseedColor = preseedColor
        }
    }

    // MARK: - Internal properties

    var config: Config

    var onTap: CXNoArgumentAction

    // MARK: - Initializers

    public init(config: Config, onTap: @escaping CXNoArgumentAction) {
        self.config = config
        self.onTap = onTap
    }

    // MARK: - View

    public var body: some View {
        Button {
            onTap()
        } label: {
            Label(config.title, systemImage: config.systemImage ?? .empty)
                .lineLimit(1)
                .labelStyle(.flex(isIconVisible: config.systemImage != nil))
                .padding()
                .foregroundStyle(config.foregroundColor)
                .background(config.backgroundColor)
                .clipShape(.capsule)
        }
        .buttonStyle(.tagButton(color: config.backgroundColor, pressedColor: config.preseedColor))
    }
}

struct CXTagButtonStyle: ButtonStyle {
    var color: Color

    var pressedColor: Color?

    init(color: Color, pressedColor: Color? = nil) {
        self.color = color
        self.pressedColor = pressedColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? (pressedColor ?? color.opacity(0.7)) : color)
            .clipShape(.capsule)
    }
}

extension ButtonStyle where Self == CXTagButtonStyle {
    static func tagButton(color: Color, pressedColor: Color? = nil) -> CXTagButtonStyle {
        CXTagButtonStyle(color: color, pressedColor: pressedColor)
    }
}
