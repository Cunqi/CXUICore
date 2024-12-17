//
//  Color+Extension.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/16/24.
//

import SwiftUI
import UIKit

public extension Color {
    /// Initialize a Color with a hex value (e.g., 0xFF0000 for red)
    /// - Parameter hex: The hex value of the color
    init(hex: Int) {
        let components = (
            R: Double((hex >> 16) & 0xFF) / 255,
            G: Double((hex >> 08) & 0xFF) / 255,
            B: Double((hex >> 00) & 0xFF) / 255
        )

        self.init(red: components.R, green: components.G, blue: components.B)
    }

    // MARK: - System Background Colors

    /// The system's background color for content layering.
    static let systemBackground = Color(uiColor: .systemBackground)

    /// The system's secondary background color for content layering.
    static let secondarySystemBackground = Color(uiColor: .secondarySystemBackground)

    /// The system's tertiary background color for content layering.
    static let tertiarySystemBackground = Color(uiColor: .tertiarySystemBackground)

    /// The system's grouped background color.
    static let systemGroupedBackground = Color(uiColor: .systemGroupedBackground)

    /// The system's secondary grouped background color.
    static let secondarySystemGroupedBackground = Color(uiColor: .secondarySystemGroupedBackground)

    /// The system's tertiary grouped background color.
    static let tertiarySystemGroupedBackground = Color(uiColor: .tertiarySystemGroupedBackground)

    // MARK: - System Label Colors

    /// The system's primary label color.
    static let label = Color(uiColor: .label)

    /// The system's secondary label color.
    static let secondaryLabel = Color(uiColor: .secondaryLabel)

    /// The system's tertiary label color.
    static let tertiaryLabel = Color(uiColor: .tertiaryLabel)

    /// The system's quaternary label color.
    static let quaternaryLabel = Color(uiColor: .quaternaryLabel)

    /// The system's placeholder text color.
    static let placeholderText = Color(uiColor: .placeholderText)

    // MARK: - System Utility Colors

    /// The system's separator color.
    static let separator = Color(uiColor: .separator)

    /// The system's opaque separator color.
    static let opaqueSeparator = Color(uiColor: .opaqueSeparator)

    /// The system's link color.
    static let link = Color(uiColor: .link)

    /// The system's tint color.
    static let tintColor = Color(uiColor: .tintColor)

    // MARK: - System Colors

    /// The system red color.
    static let systemRed = Color(uiColor: .systemRed)

    /// The system green color.
    static let systemGreen = Color(uiColor: .systemGreen)

    /// The system blue color.
    static let systemBlue = Color(uiColor: .systemBlue)

    /// The system orange color.
    static let systemOrange = Color(uiColor: .systemOrange)

    /// The system yellow color.
    static let systemYellow = Color(uiColor: .systemYellow)

    /// The system pink color.
    static let systemPink = Color(uiColor: .systemPink)

    /// The system purple color.
    static let systemPurple = Color(uiColor: .systemPurple)

    /// The system teal color.
    static let systemTeal = Color(uiColor: .systemTeal)

    /// The system indigo color.
    static let systemIndigo = Color(uiColor: .systemIndigo)

    /// The system brown color.
    static let systemBrown = Color(uiColor: .systemBrown)

    /// The system mint color.
    static let systemMint = Color(uiColor: .systemMint)

    /// The system cyan color.
    static let systemCyan = Color(uiColor: .systemCyan)

    // MARK: - Gray Colors

    /// The system gray color.
    static let systemGray = Color(uiColor: .systemGray)

    /// The system gray (2) color.
    static let systemGray2 = Color(uiColor: .systemGray2)

    /// The system gray (3) color.
    static let systemGray3 = Color(uiColor: .systemGray3)

    /// The system gray (4) color.
    static let systemGray4 = Color(uiColor: .systemGray4)

    /// The system gray (5) color.
    static let systemGray5 = Color(uiColor: .systemGray5)

    /// The system gray (6) color.
    static let systemGray6 = Color(uiColor: .systemGray6)
}
