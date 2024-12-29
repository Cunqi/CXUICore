//
//  CXCalendarContext.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/26/24.
//

import Foundation

@Observable public class CXCalendarMonthContext {
    // MARK: - Public Properties

    public private(set) var calendar: Calendar = .current

    public private(set) var locale: Locale = .current

    public private(set) var items: [CXCalendarItem] = []

    public private(set) var dateRange: ClosedRange<Date> = .distantPast ... .distantFuture

    // MARK: - Internal Properties

    private(set) var anchorMonth: Date = .now {
        didSet {
            loadItems(for: anchorMonth)
        }
    }

    var anchorYearTitle: String {
        CXDateHelper.extractYearAndMonth(from: anchorMonth).year
    }

    var anchorMonthTitle: String {
        CXDateHelper.extractYearAndMonth(from: anchorMonth).month
    }

    // MARK: - Internal methods

    func prepare(for date: Date) {
        guard let currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return
        }
        anchorMonth = currentMonth
    }

    func moveToNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: anchorMonth) {
            anchorMonth = nextMonth
        }
    }

    func moveToPrevMonth() {
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: anchorMonth) {
            anchorMonth = prevMonth
        }
    }

    // MARK: - Private methods

    private func loadItems(for month: Date) {
        let daysFromCurrentMonth = CXDateHelper.extractDays(month: month, calendar: calendar)
            .compactMap { makeCalendarItem($0) }

        var items: [CXCalendarItem] = []

        // Load leading items if needed
        if let firstDayOfCurrentMonth = daysFromCurrentMonth.first?.date {
            let daysOfLastMonth = CXDateHelper.makeLeadingDays(for: firstDayOfCurrentMonth, calendar: calendar)
                .compactMap { makeCalendarItem($0) }
            items.append(contentsOf: daysOfLastMonth)
        }

        // Load current month items
        items.append(contentsOf: daysFromCurrentMonth)

        // Load trailing items if needed
        if let lastDayOfCurrentMonth = daysFromCurrentMonth.last?.date {
            let daysOfNextMonth = CXDateHelper.makeTrailingDays(for: lastDayOfCurrentMonth, calendar: calendar)
                .compactMap { makeCalendarItem($0) }
            items.append(contentsOf: daysOfNextMonth)
        }

        self.items = items
    }

    private func makeCalendarItem(_ date: Date) -> CXCalendarItem {
        let day = calendar.component(.day, from: date)
        let isEnabled = dateRange ~= date

        return CXCalendarItem(.currentMonth, value: day, date: date, isDisabled: !isEnabled)
    }
}
