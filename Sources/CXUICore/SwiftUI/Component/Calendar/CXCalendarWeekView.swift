//
//  CXCalendarWeekView.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/27/24.
//

import SwiftUI

public struct CXCalendarWeekView<CalendarWeekItem: View>: View {
    // MARK: - Constants

    private static var numOfWeeks: Int { 4 }

    // MARK: - Internal properties

    @Binding var selectedDate: Date

    // MARK: - Private properties

    @State private var calendarFeature = CXCalendarFeature(.week)
    @State private var weekIndex = CXCalendarWeekView.numOfWeeks
    @State private var height: CGFloat = 80
    @State private var weekOffset = 0

    private var itemContent: (CXCalendarItem, Binding<Date>) -> CalendarWeekItem

    // MARK: - Initializers

    public init(selectedDate: Binding<Date>, @ViewBuilder itemContent: @escaping (CXCalendarItem, Binding<Date>) -> CalendarWeekItem) {
        _selectedDate = selectedDate
        self.itemContent = itemContent
    }

    public var body: some View {
        VStack(spacing: CXSpacing.oneX) {
            CXCalendarWeekdayBar()

            CXCarouselView { index, offset in
                CXCalendarWeekRowView(
                    index: index % CXCalendarWeekView.numOfWeeks,
                    weekOffset: $weekOffset,
                    selectedDate: $selectedDate,
                    itemContent: itemContent
                )
            }
            .onChange(of: weekIndex) { oldValue, newValue in
                if newValue < CXCalendarWeekView.numOfWeeks || newValue > CXCalendarWeekView.numOfWeeks * 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        weekIndex = CXCalendarWeekView.numOfWeeks + newValue / CXCalendarWeekView.numOfWeeks
                    }
                }
            }
        }
        .environment(calendarFeature)
        .onAppear {
            calendarFeature.prepare(for: selectedDate)
        }
    }
}

struct CXCalendarWeekRowView<CalendarWeekItem: View>: View {

    // MARK: - Internal properties

    var index: Int

    @Binding var weekOffset: Int
    @Binding var selectedDate: Date

    @State private var items: [CXCalendarItem] = []

    var itemContent: (CXCalendarItem, Binding<Date>) -> CalendarWeekItem

    // MARK: - Private properties

    @Environment(CXCalendarFeature.self) private var calendarFeature

    var body: some View {
        LazyVGrid(columns: calendarFeature.metadata.columns, spacing: .zero) {
            ForEach(calendarFeature.weekContext.items) { item in
                itemContent(item, $selectedDate)
            }
        }
//        .onChange(of: weekOffset) { oldValue, newValue in
//            print("OnChange Index: \(index) offset: \(weekOffset)")
//        }
//        .onAppear {
//            print("OnAppear Index: \(index) offset: \(weekOffset)")
//        }
    }
}

// MARK: - Extensions

public extension CXCalendarWeekView {
    func weekdaySymbols(_ symbols: [String]) -> Self {
        calendarFeature.metadata.weekdays = symbols.map { CXCalendarWeekday(symbol: $0) }
        return self
    }
}
