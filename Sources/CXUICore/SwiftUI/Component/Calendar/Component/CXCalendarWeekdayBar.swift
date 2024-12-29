//
//  CXCalendarWeekdayBar.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/25/24.
//

import SwiftUI

struct CXCalendarWeekdayBar: View {

    @Environment(CXCalendarFeature.self) private var calendarFeature

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(calendarFeature.metadata.weekdays) { weekday in
                Text(weekday.symbol)
                    .font(.body.bold())
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    CXCalendarWeekdayBar()
}
