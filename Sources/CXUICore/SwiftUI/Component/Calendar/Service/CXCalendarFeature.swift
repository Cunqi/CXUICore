//
//  CXCalendarFeature.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/26/24.
//

import SwiftUI

@Observable public class CXCalendarFeature {
    enum ContextType {
        case month, week
    }

    // MARK: - Public Properties

    public private(set) var monthContext = CXCalendarMonthContext()

    public private(set) var metadata = CXCalendarMetadata()

    public private(set) var weekContext = CXCalendarWeekContext()

    // MARK: - Private Properties

    private let contextType: ContextType

    // MARK: - Initializers

    init(_ contextType: ContextType) {
        self.contextType = contextType
    }

    // MARK: - Internal methods

    func prepare(for date: Date) {
        switch contextType {
        case .month:
            monthContext.prepare(for: date)
        case .week:
            weekContext.prepare(for: date)
        }
    }
}
