//
//  CXCalendarGridView.swift
//  Seed
//
//  Created by Cunqi Xiao on 12/25/24.
//

import SwiftUI

struct CXCalendarGridView<GridItemView: View>: View {
    @Binding var selectedDate: Date

    var itemContent: (CXCalendarItem, Binding<Date>) -> GridItemView

    // MARK: - Private properties

    @Environment(CXCalendarFeature.self) private var calendarFeature

    // MARK: - Initializers

    public init(selectedDate: Binding<Date>, currentMonth _: Int) where GridItemView == CXCalendarGridItemView {
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

    var body: some View {
        LazyVGrid(columns: calendarFeature.metadata.columns, spacing: .zero) {
            ForEach(calendarFeature.monthContext.items) { item in
                itemContent(item, $selectedDate)
            }
        }
    }
}
