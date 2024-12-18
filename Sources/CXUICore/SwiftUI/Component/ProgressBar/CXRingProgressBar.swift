//
//  CXRingProgressBar.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import SwiftUI

/// A circular progress indicator that displays progress as a ring with support for infinite loading animation.
///
/// `CXRingProgressBar` is a versatile progress indicator that can show both determinate progress and
/// infinite loading states. When in infinite loading mode, it displays a rotating ring segment that
/// creates a continuous loading animation.
///
/// Example usage:
/// ```swift
/// //Determinate progress
/// CXRingProgressBar(
///     config: .init(infinityLoadingWhileIdle: false),
///     progress: .constant(0.75)
/// )
///
/// // Infinite loading
/// CXRingProgressBar(
///     config: .init(infinityLoadingWhileIdle: true),
///     progress: .constant(0)
/// )
/// ```
public struct CXRingProgressBar: View {
    // MARK: - Constants

    /// Length of the progress bar segment in infinite loading mode (0.3 = 30% of the circle).
    private static let barLength: Double = 0.3
    /// Time interval between updates in infinite loading animation.
    private static let updateInterval: Double = 0.15
    /// Amount to increment progress in each update of infinite loading.
    private static let updateIncrement: Double = 0.1
    /// Maximum progress value for infinite loading before resetting to zero.
    private static let maxInfinityProgress: Double = 1.5

    /// Configuration options for customizing the appearance and behavior of the ring progress bar.
    public struct Config {
        /// The color of the progress ring.
        public var foregroundColor: Color

        /// The color of the background ring.
        public var backgroundColor: Color

        /// The size of the progress ring.
        public var size: CGSize

        /// The width of the progress ring stroke.
        public var strokeWidth: CGFloat

        /// Whether to show infinite loading animation when progress is zero.
        public var infinityLoadingWhileIdle: Bool

        /// Creates a new configuration with the specified parameters.
        ///
        /// - Parameters:
        ///   - foregroundColor: The color of the progress ring. Defaults to system blue.
        ///   - backgroundColor: The color of the background ring. Defaults to system gray.
        ///   - size: The size of the progress ring. Defaults to six times the base spacing.
        ///   - strokeWidth: The width of the ring stroke. Defaults to half the base spacing.
        ///   - infinityLoadingWhileIdle: Whether to show infinite loading when progress is zero. Defaults to true.
        public init(
            foregroundColor: Color = .systemBlue,
            backgroundColor: Color = .systemGray,
            size: CGSize = .init(square: CXSpacing.sixX),
            strokeWidth: CGFloat = CXSpacing.halfX,
            infinityLoadingWhileIdle: Bool = true
        ) {
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.size = .init(square: size.shortestEdge)
            self.strokeWidth = strokeWidth
            self.infinityLoadingWhileIdle = infinityLoadingWhileIdle
        }
    }

    /// The configuration for the progress bar's appearance and behavior.
    var config: Config

    /// The current progress value, from 0.0 to 1.0.
    @Binding var progress: Double

    // MARK: - Private properties

    /// Timer for driving the infinite loading animation.
    @State private var timer: Timer?
    /// Current progress value for infinite loading animation.
    @State private var infinityProgress: Double = .zero

    /// Whether the progress bar is currently in infinite loading mode.
    private var isInfinityLoading: Bool {
        config.infinityLoadingWhileIdle && progress == .zero
    }

    /// The actual progress value to display, accounting for infinite loading state.
    private var liveProgress: Double {
        isInfinityLoading ? infinityProgress : progress
    }

    /// The starting point of the progress ring segment.
    private var trimFrom: Double {
        isInfinityLoading ? infinityProgress - Self.barLength : .zero
    }

    /// The ending point of the progress ring segment.
    private var trimTo: Double {
        liveProgress
    }

    // MARK: - Initializers

    /// Creates a new ring progress bar with the specified configuration and progress binding.
    ///
    /// - Parameters:
    ///   - config: Configuration options for the progress bar's appearance and behavior.
    ///   - progress: A binding to the progress value (0.0 to 1.0).
    public init(config: Config, progress: Binding<Double>) {
        self.config = config
        _progress = progress
    }

    // MARK: - Views

    public var body: some View {
        ZStack {
            Circle()
                .stroke(config.backgroundColor, style: StrokeStyle(lineWidth: config.strokeWidth))
                .frame(size: config.size)

            Circle()
                .trim(from: trimFrom, to: trimTo)
                .stroke(config.foregroundColor, style: StrokeStyle(lineWidth: config.strokeWidth, lineCap: .round))
                .frame(size: config.size)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
        .onAppear {
            guard isInfinityLoading else {
                reset()
                return
            }

            timer = Timer.scheduledTimer(withTimeInterval: CXRingProgressBar.updateInterval, repeats: true) { _ in
                Task { @MainActor in
                    withAnimation {
                        infinityProgress += CXRingProgressBar.updateIncrement
                    }

                    if infinityProgress > CXRingProgressBar.maxInfinityProgress {
                        infinityProgress = .zero
                    }
                }
            }
        }
        .onDisappear {
            reset()
        }
    }

    /// Resets the infinite loading animation state.
    private func reset() {
        timer?.invalidate()
        timer = nil
        infinityProgress = .zero
    }
}

#Preview {
    CXRingProgressBar(config: .init(), progress: .constant(0))
}
