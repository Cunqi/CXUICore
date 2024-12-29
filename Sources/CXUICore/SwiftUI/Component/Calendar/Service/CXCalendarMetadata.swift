//
//  SeedCalendarMetadata.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/26/24.
//

import SwiftUI

@Observable public class CXCalendarMetadata {

    // MARK: - Internal Properties

    var weekdays: [CXCalendarWeekday]

    // MARK: - Internal Properties

    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    // MARK: - Initializers

    init() {
        weekdays = CXDateHelper.yearMonthFormatter.veryShortWeekdaySymbols.map { CXCalendarWeekday(symbol: $0) }
    }

}
