//
//  CXDateHelper.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/26/24.
//

import Foundation

class CXDateHelper {
    static let yearMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MMMM"
        return formatter
    }()

    static func extractYearAndMonth(from date: Date) -> (year: String, month: String) {
        let components = yearMonthFormatter.string(from: date).components(separatedBy: "-")
        return (components[0], components[1])
    }

    static func makeLeadingDays(for firstDayOfMonth: Date, calendar: Calendar) -> [Date] {
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        return (1 ..< firstWeekday).reversed().compactMap {
            calendar.date(byAdding: .day, value: -1 * $0, to: firstDayOfMonth)
        }
    }

    static func makeTrailingDays(for lastDayOfMonth: Date, calendar: Calendar) -> [Date] {
        let lastWeekday = calendar.component(.weekday, from: lastDayOfMonth)
        return (0 ..< 7 - lastWeekday).compactMap {
            calendar.date(byAdding: .day, value: $0 + 1, to: lastDayOfMonth)
        }
    }

    static func makeFirstDayOfWeek(for date: Date, calendar: Calendar) -> Date {
        let weekday = calendar.component(.weekday, from: date) - 1
        return calendar.date(byAdding: .day, value: -weekday, to: date)!
    }

    static func extractDays(month date: Date, calendar: Calendar) -> [Date] {
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let days = calendar.range(of: .day, in: .month, for: firstDayOfMonth)
        else {
            return []
        }
        return (0 ..< days.count).compactMap {
            calendar.date(byAdding: .day, value: $0, to: firstDayOfMonth)
        }
    }

    static func extractDays(firstDayOfWeek date: Date, calendar: Calendar) -> [Date] {
        return (0 ..< 7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: date)
        }
    }
}
