//
//  CXCalendarWeekContext.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/27/24.
//

import Foundation

@Observable public class CXCalendarWeekContext {
    // MARK: - Public Properties

    public private(set) var calendar: Calendar = .current

    public private(set) var locale: Locale = .current

    public private(set) var items: [CXCalendarItem] = []

    public private(set) var dateRange: ClosedRange<Date> = .distantPast ... .distantFuture

    // MARK: - Internal Properties

    private(set) var anchorWeek: Date = .now {
        didSet {
            loadItems(for: anchorWeek)
        }
    }

    // MARK: - Internal methods

    func prepare(for date: Date) {
        anchorWeek = CXDateHelper.makeFirstDayOfWeek(for: date, calendar: calendar)
    }

    func moveToNextWeek() {
        if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: anchorWeek) {
            anchorWeek = nextWeek
        }
    }

    func moveToPrevWeek() {
        if let prevWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: anchorWeek) {
            anchorWeek = prevWeek
        }
    }

    // MARK: - Private methods

    private func loadItems(for firstDayOfWeek: Date) {
        let daysFromCurrentWeek = CXDateHelper.extractDays(firstDayOfWeek: firstDayOfWeek, calendar: calendar)
            .compactMap { makeCalendarItem($0) }

        // var items: [CXCalendarItem] = []

        // // Load leading items if needed
        // if let firstDayOfCurrentMonth = daysFromCurrentMonth.first?.date {
        //     let daysOfLastMonth = CXDateHelper.makeLeadingDays(for: firstDayOfCurrentMonth, calendar: calendar)
        //         .compactMap { makeCalendarItem($0) }
        //     items.append(contentsOf: daysOfLastMonth)
        // }

        // // Load current month items
        // items.append(contentsOf: daysFromCurrentMonth)

        // // Load trailing items if needed
        // if let lastDayOfCurrentMonth = daysFromCurrentMonth.last?.date {
        //     let daysOfNextMonth = CXDateHelper.makeTrailingDays(for: lastDayOfCurrentMonth, calendar: calendar)
        //         .compactMap { makeCalendarItem($0) }
        //     items.append(contentsOf: daysOfNextMonth)
        // }

        items = daysFromCurrentWeek
    }

    private func makeCalendarItem(_ date: Date) -> CXCalendarItem {
        let day = calendar.component(.day, from: date)
        let isEnabled = dateRange ~= date

        return CXCalendarItem(.currentMonth, value: day, date: date, isDisabled: !isEnabled)
    }
}
