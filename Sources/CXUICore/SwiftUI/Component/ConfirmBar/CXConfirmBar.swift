//
//  CXConfirmBar.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

/// A protocol defining the properties and behavior of a confirmation bar action.
/// Implement this protocol to create custom actions for the confirmation bar.
public protocol CXConfirmBarAction {
    /// The type of action this represents (cancel, confirm, or none).
    var actionType: CXConfirmBar.ActionType { get }

    /// The localized title text to display on the action button.
    var title: LocalizedStringKey { get }

    /// Optional system image name to display alongside the title.
    var systemImage: String? { get }

    /// The color to apply to the text and icon.
    var foregroundColor: Color { get }

    /// The background color of the action button.
    var backgroundColor: Color { get }

    /// The action to perform when the button is tapped.
    var action: () -> Void { get }
}

/// A customizable confirmation bar component that provides styled action buttons.
/// This component is typically used at the bottom of forms or modal views to provide
/// consistent confirmation and cancellation options.
///
/// Features:
/// - Customizable button labels and styles
/// - Support for system images
/// - Flexible action handling
/// - Configurable colors and spacing
///
/// Example usage:
/// ```swift
/// CXConfirmBar(
///     cancelAction: CXConfirmBarCancelAction(
///         title: "Cancel",
///         action: dismissForm
///     ),
///     confirmAction: CXConfirmBarConfirmAction(
///         title: "Save",
///         systemImage: "checkmark",
///         action: saveChanges
///     )
/// )
/// ```
public struct CXConfirmBar: View {
    /// Defines the type of action a button represents.
    public enum ActionType {
        /// Represents a cancellation or dismissal action
        case cancel
        /// Represents a confirmation or completion action
        case confirm
        /// Represents a neutral or undefined action
        case none
    }

    /// The action to perform for cancellation
    var cancelAction: CXConfirmBarAction
    /// Optional action to perform for confirmation
    var confirmAction: CXConfirmBarAction?
    /// The spacing between action buttons
    var spacing: CGFloat?

    // MARK: - Initializers

    /// Creates a new confirmation bar with the specified actions.
    /// - Parameters:
    ///   - cancelAction: The action for the cancel button
    ///   - confirmAction: Optional action for the confirm button
    ///   - spacing: Optional spacing between buttons (uses system default if nil)
    public init(cancelAction: CXConfirmBarAction, confirmAction: CXConfirmBarAction? = nil, spacing: CGFloat? = nil) {
        self.cancelAction = cancelAction
        self.confirmAction = confirmAction
        self.spacing = spacing
    }

    // MARK: - Views

    public var body: some View {
        HStack(spacing: spacing) {
            ActionButton(action: cancelAction)

            if let confirmAction {
                ActionButton(action: confirmAction)
            }
        }
    }

    /// Creates a styled button for the given action.
    /// - Parameter action: The action configuration to use for the button
    /// - Returns: A styled button view
    @ViewBuilder
    private func ActionButton(action: CXConfirmBarAction) -> some View {
        Button(action: action.action) {
            Label(action.title, systemImage: action.systemImage ?? "")
                .labelStyle(.flex(isIconVisible: action.systemImage != nil))
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(action.foregroundColor)
                .background(action.backgroundColor)
                .clipShape(.capsule)
        }
    }
}

// MARK: - Cancel Action

/// A concrete implementation of CXConfirmBarAction for cancel buttons.
/// Provides default styling and behavior appropriate for cancellation actions.
public struct CXConfirmBarCancelAction: CXConfirmBarAction {
    public var actionType: CXConfirmBar.ActionType = .cancel
    public var title: LocalizedStringKey = "Cancel"
    public var systemImage: String? = nil
    public var foregroundColor: Color = .primary
    public var backgroundColor: Color = .systemGray

    public var action: () -> Void = {}

    /// Creates a new cancel action with customizable properties.
    /// - Parameters:
    ///   - title: The localized text to display (default: "Cancel")
    ///   - systemImage: Optional system image name
    ///   - foregroundColor: Color for text and icon (default: .primary)
    ///   - backgroundColor: Button background color (default: .systemGray)
    ///   - action: Action to perform when tapped
    public init(title: LocalizedStringKey = "Cancel",
                systemImage: String? = nil,
                foregroundColor: Color = .primary,
                backgroundColor: Color = .systemGray,
                action: @escaping () -> Void = {})
    {
        self.title = title
        self.systemImage = systemImage
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
    }
}

// MARK: - Confirm Action

/// A concrete implementation of CXConfirmBarAction for confirm buttons.
/// Provides default styling and behavior appropriate for confirmation actions.
public struct CXConfirmBarConfirmAction: CXConfirmBarAction {
    public var actionType: CXConfirmBar.ActionType = .confirm
    public var title: LocalizedStringKey = "Confirm"
    public var systemImage: String? = nil
    public var foregroundColor: Color = .primary
    public var backgroundColor: Color = .systemGray

    public var action: () -> Void = {}

    /// Creates a new confirm action with customizable properties.
    /// - Parameters:
    ///   - title: The localized text to display (default: "Confirm")
    ///   - systemImage: Optional system image name
    ///   - foregroundColor: Color for text and icon (default: .primary)
    ///   - backgroundColor: Button background color (default: .systemGray)
    ///   - action: Action to perform when tapped
    public init(title: LocalizedStringKey = "Confirm",
                systemImage: String? = nil,
                foregroundColor: Color = .primary,
                backgroundColor: Color = .systemGray,
                action: @escaping () -> Void = {})
    {
        self.title = title
        self.systemImage = systemImage
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
    }
}

#Preview {
    VStack {
        Spacer()

        // Default configuration
        CXConfirmBar(
            cancelAction: CXConfirmBarCancelAction(),
            confirmAction: CXConfirmBarConfirmAction()
        )

        // Custom configuration
        CXConfirmBar(
            cancelAction: CXConfirmBarCancelAction(
                title: "Discard",
                foregroundColor: .white,
                backgroundColor: .red
            ),
            confirmAction: CXConfirmBarConfirmAction(
                title: "Save",
                systemImage: "checkmark",
                foregroundColor: .white,
                backgroundColor: .blue
            ),
            spacing: CXSpacing.twoX
        )
    }
    .padding()
}