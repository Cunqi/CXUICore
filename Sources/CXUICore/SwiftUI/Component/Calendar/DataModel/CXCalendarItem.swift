//
//  CXCalendarItem.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/26/24.
//

import Foundation

public enum CXCalendarGridItemType {
    case currentMonth, lastMonth, nextMonth
}

public struct CXCalendarItem: Identifiable {
    public var id: String = UUID().uuidString

    public var type: CXCalendarGridItemType = .currentMonth

    public var isDisabled: Bool = false

    public var value: Int

    public var date: Date

    // MARK: - Initializers

    init(_ type: CXCalendarGridItemType, value: Int, date: Date, isDisabled: Bool = false) {
        self.type = type
        self.value = value
        self.date = date
        self.isDisabled = isDisabled
    }
}
