//
//  CXCalendarGridItemView.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/25/24.
//

import SwiftUI

public struct CXCalendarGridItemView: View {
    // MARK: - Internal properties

    var item: CXCalendarItem

    @Binding var selectedDate: Date

    private var isSelected: Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: item.date)
    }

    private var text: String {
        item.isDisabled ? "" : item.value.description
    }

    public var body: some View {
        VStack {
            Text(text)
                .foregroundStyle(item.type == .currentMonth ? .primary : .secondary)
        }
        .padding(.vertical, CXSpacing.oneX)
        .frame(maxWidth: .infinity)
        .background {
            Capsule()
                .fill(Color.accentColor)
                .padding(.horizontal, CXSpacing.oneX)
                .opacity(isSelected ? 1 : 0)
        }
        .allowsHitTesting(!item.isDisabled)
        .onTapGesture {
            withAnimation {
                selectedDate = item.date
            }
        }
    }
}
