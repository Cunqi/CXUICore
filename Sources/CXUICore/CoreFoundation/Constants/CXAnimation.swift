//
//  CXAnimation.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/16/24.
//

import Foundation

/// Namespace for animation-related constants and configurations.
public enum CXAnimation {
    /// Constants for commonly used animation durations throughout the application.
    /// These durations are carefully chosen to provide a consistent and pleasant user experience
    /// across different types of animations.
    public enum Duration {
        /// Ultra-fast duration (0.083s) for micro-interactions.
        /// Suitable for:
        /// - Immediate visual feedback
        /// - Micro-animations
        /// - State changes
        public static let fast: TimeInterval = 0.083

        /// Quick duration (0.167s) for responsive interactions.
        /// Suitable for:
        /// - Button presses
        /// - Simple highlights
        /// - Quick state transitions
        public static let quick: TimeInterval = 0.167

        /// Standard duration (0.25s) for common animations.
        /// Suitable for:
        /// - Basic transitions
        /// - UI element changes
        /// - Simple transformations
        public static let standard: TimeInterval = 0.25

        /// Focused duration (0.334s) for deliberate animations.
        /// Suitable for:
        /// - View transitions
        /// - Content changes
        /// - Attention-drawing animations
        public static let focused: TimeInterval = 0.334

        /// Important duration (0.5s) for significant changes.
        /// Suitable for:
        /// - Important state changes
        /// - Complex transitions
        /// - User-focused animations
        public static let important: TimeInterval = 0.5

        /// Casual duration (0.667s) for relaxed animations.
        /// Suitable for:
        /// - Casual transitions
        /// - Natural movements
        /// - Smooth state changes
        public static let casual: TimeInterval = 0.667

        /// Slow duration (0.834s) for deliberate transitions.
        /// Suitable for:
        /// - Elaborate transitions
        /// - Educational animations
        /// - Guided interactions
        public static let slow: TimeInterval = 0.834

        /// Long duration (1.0s) for major transitions.
        /// Suitable for:
        /// - Page transitions
        /// - Launch sequences
        /// - Complex visual effects
        public static let long: TimeInterval = 1.0
    }

    /// Constants for commonly used animation delays.
    /// These delays help create staggered animations and sequential effects
    /// for a more polished user experience.
    public enum Delay {
        /// No delay (0.0s) for immediate animations.
        /// Use when animations should start immediately.
        public static let none: TimeInterval = 0.0

        /// Short delay (0.25s) for staggered effects.
        /// Suitable for:
        /// - List item animations
        /// - Sequential transitions
        /// - Subtle timing effects
        public static let short: TimeInterval = 0.25

        /// Medium delay (0.5s) for noticeable pauses.
        /// Suitable for:
        /// - Multi-step animations
        /// - Dialog sequences
        /// - Clear timing separation
        public static let medium: TimeInterval = 0.5

        /// Long delay (1.0s) for dramatic pauses.
        /// Suitable for:
        /// - Major state changes
        /// - Attention-drawing sequences
        /// - Extended transition sequences
        public static let long: TimeInterval = 1.0
    }
}
