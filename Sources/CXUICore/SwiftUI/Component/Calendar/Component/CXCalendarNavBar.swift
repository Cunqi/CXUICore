//
//  CXCalendarNavBar.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/25/24.
//

import SwiftUI

struct CXCalendarNavBar: View {
    var selectedDate: Date

    // MARK: - Private properties

    @Environment(CXCalendarFeature.self) private var calendarFeature

    var body: some View {
        HStack(spacing: CXSpacing.threeX) {
            VStack(alignment: .leading, spacing: CXSpacing.oneX) {
                Text(calendarFeature.monthContext.anchorYearTitle)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(calendarFeature.monthContext.anchorMonthTitle)
                    .font(.title.bold())
            }

            Spacer()

            Button {
                withAnimation {
                    calendarFeature.monthContext.moveToPrevMonth()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }

            Button {
                withAnimation {
                    calendarFeature.monthContext.moveToNextMonth()
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CXCalendarNavBar(selectedDate: .now)
}
