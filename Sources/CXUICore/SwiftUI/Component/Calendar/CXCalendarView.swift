//
//  CXCalendarView.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/25/24.
//

import SwiftUI

public struct CXCalendarView<GridItemView: View>: View {
    // MARK: - Internal properties

    @Binding var selectedDate: Date

    // MARK: - Private properties

    @State private var calendarFeature = CXCalendarFeature(.month)

    private var itemContent: (CXCalendarItem, Binding<Date>) -> GridItemView

    // MARK: - Initializers

    public init(selectedDate: Binding<Date>) where GridItemView == CXCalendarGridItemView {
        _selectedDate = selectedDate
        itemContent = { item, selectedDate in
            CXCalendarGridItemView(item: item, selectedDate: selectedDate)
        }
    }

    public init(selectedDate: Binding<Date>, @ViewBuilder itemContent: @escaping (CXCalendarItem, Binding<Date>) -> GridItemView) {
        _selectedDate = selectedDate
        self.itemContent = itemContent
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: CXSpacing.threeX) {
            CXCalendarNavBar(selectedDate: selectedDate)
            CXCalendarWeekdayBar()
            CXCalendarGridView(selectedDate: $selectedDate, itemContent: itemContent)
        }
        .environment(calendarFeature)
        .onAppear {
            calendarFeature.prepare(for: selectedDate)
        }
    }
}

// MARK: - Extensions

public extension CXCalendarView {
    func weekdaySymbols(_ symbols: [String]) -> Self {
        calendarFeature.metadata.weekdays = symbols.map { CXCalendarWeekday(symbol: $0) }
        return self
    }
}

#Preview {
    CXCalendarView(selectedDate: .constant(.now))
}
