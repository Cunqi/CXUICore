//
//  CXDatePickerConfig.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import CXFoundation
import SwiftUI

public struct CXDatePickerConfig<DateComponent> where DateComponent: CXDateComponent {
    public var title: LocalizedStringKey

    public var items: [DateComponent]

    var numOfColumns = 4

    var numOfLeadingEmptyItems = 0

    var minItem: DateComponent?

    var maxItem: DateComponent?

    var titles: [String] = []

    var isTitlesVisible: Bool {
        !titles.isEmpty
    }

    func isDisabled(for item: DateComponent) -> Bool {
        guard minItem != nil || maxItem != nil else {
            return false
        }

        if let minItem, item < minItem {
            return true
        }

        if let maxItem, item > maxItem {
            return true
        }

        return false
    }
}

public extension CXDatePickerConfig where DateComponent == CXDateComponentYear {
    static func year(years: Range<Int>, minItem: DateComponent? = nil, maxItem: DateComponent? = nil) -> CXDatePickerConfig {
        CXDatePickerConfig(
            title: "Year",
            items: CXDateComponentYear.makeYears(years),
            minItem: minItem,
            maxItem: maxItem
        )
    }

    static func year(years: [CXDateComponentYear]) -> CXDatePickerConfig {
        CXDatePickerConfig(
            title: "Year",
            items: years
        )
    }
}

public extension CXDatePickerConfig where DateComponent == CXDateComponentMonth {
    static func month(
        calendar: Calendar = .current,
        minItem: DateComponent? = nil,
        maxItem: DateComponent? = nil,
        monthStyle: CXDateComponentMonth.MonthStyle = .short) -> CXDatePickerConfig {
        CXDatePickerConfig(
            title: "Month",
            items: CXDateComponentMonth.makeMonths(calendar: calendar, monthStyle: monthStyle),
            minItem: minItem,
            maxItem: maxItem
        )
    }
}

public extension CXDatePickerConfig where DateComponent == CXDateComponentDay {
    static func day(calendar: Calendar = Calendar.current, date: Date, minItem: DateComponent? = nil, maxItem: DateComponent? = nil) -> CXDatePickerConfig {
        CXDatePickerConfig(
            title: "Day",
            items: CXDateComponentDay.makeDays(calendar: calendar, date: date),
            numOfColumns: 7,
            numOfLeadingEmptyItems: CXDateComponentDay.makeEmptyDaysAtStart(calendar: calendar, date: date),
            minItem: minItem,
            maxItem: maxItem,
            titles: calendar.shortWeekdaySymbols
        )
    }
}
