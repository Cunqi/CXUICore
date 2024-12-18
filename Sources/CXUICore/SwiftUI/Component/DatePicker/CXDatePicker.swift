//
//  CXDatePicker.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import CXFoundation
import SwiftUI

public struct CXDatePicker<DateComponent: CXDateComponent>: View {

    // MARK: - Internal properties

     var config: CXDatePickerConfig<DateComponent>

    @Binding var selectedItem: DateComponent

    // MARK: - Initializers

    public init(config: CXDatePickerConfig<DateComponent>, selectedItem: Binding<DateComponent>) {
        self.config = config
        self._selectedItem = selectedItem
    }

    // MARK: - Views

    public var body: some View {
        VStack {
            if config.isTitlesVisible {
                HStack {
                    ForEach(config.titles, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    }
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: config.numOfColumns)) {
                ForEach(Array(0..<config.numOfLeadingEmptyItems).map { $0 }, id: \.hashValue) { _ in
                    Text("")
                }

                ForEach(config.items) { item in
                    Text(item.description)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .padding(CXSpacing.oneX)
                        .background(backgroundColor(for: item))
                        .clipShape(.capsule)
                        .allowsHitTesting(!isDisabled(for: item))
                        .onTapGesture {
                            selectedItem = item
                        }
                }
                .monospacedDigit()
            }
        }
    }

    // MARK: - Private methods

    private func isDisabled(for item: DateComponent) -> Bool {
        guard config.minItem != nil || config.maxItem != nil else {
            return false
        }

        if let minItem = config.minItem, item < minItem {
            return true
        }

        if let maxItem = config.maxItem, item > maxItem {
            return true
        }

        return false
    }

    private func backgroundColor(for item: DateComponent) -> Color {
        if selectedItem == item {
            return .blue
        } else if isDisabled(for: item) {
            return .systemGray6
        } else {
            return .systemGray3
        }
    }
 }

#Preview {
    VStack {
        CXDatePicker(config: .year(years: 2020..<2025), selectedItem: .constant(.init(2021)))

        CXDatePicker(config: .month(), selectedItem: .constant(.init(1)))
    }

}
