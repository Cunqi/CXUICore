//
//  CXDatePickerConfig.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import CXFoundation
import SwiftUI

@available(iOS 16.0, *)
public struct CXDatePickerConfig<DateComponent> where DateComponent: CXDateComponent {
    public var items: [DateComponent]

    public var leadingItems: [DateComponent] = []

    public var trailingItems: [DateComponent] = []

    public var minItem: DateComponent?

    public var maxItem: DateComponent?

    public var titleForegroundColor: Color = .secondary

    public var titleBackgroundColor: Color = .clear

    public var itemSpacing: CGFloat = CXSpacing.oneX

    public var itemContentSpacing: CGFloat = .zero

    public var itemBackgroundColor: Color = .gray

    public var itemSelectedBackgroundColor: Color = .blue

    public var itemDisabledBackgroundColor: Color = .systemGray6

    public var itemForegroundColor: Color = .primary

    public var itemSecondaryForegroundColor: Color = .secondary

    public var itemSelectedForegroundColor: Color = .primary

    public var itemFont: Font = .body

    public var itemShape: AnyShape = AnyShape(.circle)

    public var isSiblingItemsVisible: Bool = true

    var titles: [String] = []

    var numOfColumns = 4

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

@available(iOS 16.0, *)
public extension CXDatePickerConfig where DateComponent == CXDateComponentYear {
    static func year(years: Range<Int>, minItem: DateComponent? = nil, maxItem: DateComponent? = nil) -> CXDatePickerConfig {
        CXDatePickerConfig(
            items: years.map { CXDateComponentYear($0) },
            minItem: minItem,
            maxItem: maxItem,
            itemContentSpacing: CXSpacing.oneX,
            itemShape: AnyShape(.rect(cornerRadius: CXCornerRadius.small, style: .circular))
        )
    }

    static func year(years: [CXDateComponentYear]) -> CXDatePickerConfig {
        CXDatePickerConfig(
            items: years
        )
    }
}

@available(iOS 16.0, *)
public extension CXDatePickerConfig where DateComponent == CXDateComponentMonth {
    static func months(
        year: Int,
        minItem: DateComponent? = nil,
        maxItem: DateComponent? = nil,
        symbols: [String] = Calendar.current.shortMonthSymbols
    ) -> CXDatePickerConfig {
        CXDatePickerConfig(
            items: (1 ... 12).map { CXDateComponentMonth(year: year, month: $0) },
            minItem: minItem,
            maxItem: maxItem,
            itemContentSpacing: CXSpacing.oneX,
            itemShape: AnyShape(.rect(cornerRadius: CXCornerRadius.small, style: .circular))
        )
    }

    static func months(from date: Date,
                       minItem: DateComponent? = nil,
                       maxItem: DateComponent? = nil,
                       symbols: [String] = Calendar.current.shortMonthSymbols) -> CXDatePickerConfig {
        months(year: CXDateComponentYear(date).value, minItem: minItem, maxItem: maxItem, symbols: symbols)
    }
}

@available(iOS 16.0, *)
public extension CXDatePickerConfig where DateComponent == CXDateComponentDay {
    static func days(from month: CXDateComponentMonth,
                     titles: [String] = Calendar.current.shortWeekdaySymbols,
                     minItem: CXDateComponentDay? = nil,
                     maxItem: CXDateComponentDay? = nil) -> CXDatePickerConfig {
        .init(
            items: month.generateDays(),
            leadingItems: month.generateLeadingDays(),
            trailingItems: month.generateTrailingDays(),
            minItem: minItem,
            maxItem: maxItem,
            titles: titles,
            numOfColumns: 7
        )
    }

    static func days(from date: Date,
                     titles: [String] = Calendar.current.shortWeekdaySymbols,
                     minItem: CXDateComponentDay? = nil,
                     maxItem: CXDateComponentDay? = nil) -> CXDatePickerConfig {
        days(
            from: CXDateComponentMonth(date),
            titles: titles,
            minItem: minItem,
            maxItem: maxItem
        )
    }
}

extension CXDateComponentMonth {
    func generateDays(calendar: Calendar = .current, monthSymbols: [String] = Calendar.current.shortMonthSymbols) -> [CXDateComponentDay] {
        guard let date = date(calendar: calendar),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        return range.map { CXDateComponentDay(month: .init(year: year.value, month: value), day: $0) }
    }

    func generateLeadingDays(calendar: Calendar = .current, monthSymbols: [String] = Calendar.current.shortMonthSymbols) -> [CXDateComponentDay] {
        guard let currentMonth = date(calendar: calendar),
              let lastMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth),
              let lastDayOfLastMonth = calendar.range(of: .day, in: .month, for: lastMonth)?.upperBound else {
            return []
        }
        let numOfLeadingDays = makeNumOfLeadingDays(calendar: calendar, date: currentMonth)
        let range = lastDayOfLastMonth - numOfLeadingDays ..< lastDayOfLastMonth
        let lastDateFieldMonth = CXDateComponentMonth(lastMonth, calendar: calendar)
        return range.map { CXDateComponentDay(month: lastDateFieldMonth, day: $0) }
    }

    func generateTrailingDays(calendar: Calendar = .current, monthSymbols: [String] = Calendar.current.shortMonthSymbols) -> [CXDateComponentDay] {
        guard let currentMonth = date(calendar: calendar),
              let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) else {
            return []
        }

        let numOfTrailingDays = makeNumOfTrailingDays(calendar: calendar, date: currentMonth)
        let nextDateFieldMonth = CXDateComponentMonth(nextMonth, calendar: calendar)
        let range = 1 ... numOfTrailingDays
        return range.map { CXDateComponentDay(month: nextDateFieldMonth, day: $0) }
    }

    private func makeNumOfLeadingDays(calendar: Calendar = Calendar.current, date: Date) -> Int {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return 0
        }
        return calendar.component(.weekday, from: firstDayOfMonth) - 1
    }

    private func makeNumOfTrailingDays(calendar: Calendar = Calendar.current, date: Date) -> Int {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components),
              let firstDayOfNextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth) else {
            return 0
        }
        return calendar.component(.weekday, from: firstDayOfNextMonth)
    }
}

