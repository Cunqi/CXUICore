//
//  CXDatePicker.swift
//  CXUICore
//
//  Created by Cunqi Xiao on 12/17/24.
//

import CXFoundation
import SwiftUI

@available(iOS 16.0, *)
public struct CXDatePicker<DateComponent: CXDateComponent, Content: View>: View {

    // MARK: - Internal properties

     var config: CXDatePickerConfig<DateComponent>

    @Binding var selectedItem: DateComponent

    var content: (DateComponent, CXDatePickerConfig<DateComponent>) -> Content

    private var availableItems: [DateComponent] {
        return (config.isSiblingItemsVisible ? config.leadingItems : [])
        + config.items
        + (config.isSiblingItemsVisible ? config.trailingItems : [])
    }

    // MARK: - Initializers

    public init(config: CXDatePickerConfig<DateComponent>, selectedItem: Binding<DateComponent>) where Content == EmptyView {
        self.config = config
        self._selectedItem = selectedItem
        self.content = { _, _ in EmptyView() }
    }

    public init(config: CXDatePickerConfig<DateComponent>,
                selectedItem: Binding<DateComponent>,
                @ViewBuilder extraInfoView: @escaping (DateComponent, CXDatePickerConfig<DateComponent>) -> Content) {
        self.config = config
        self._selectedItem = selectedItem
        self.content = extraInfoView
    }

    // MARK: - Views

    public var body: some View {
        VStack {
            if config.isTitlesVisible {
                HStack(spacing: config.itemSpacing) {
                    ForEach(config.titles, id: \.self) { weekdaySymbol in
                        Text(weekdaySymbol)
                            .font(config.itemFont.bold())
                            .frame(maxWidth: .infinity)
                            .foregroundColor(config.titleForegroundColor)
                    }
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: config.itemSpacing), count: config.numOfColumns), spacing: config.itemSpacing) {
                if !config.isSiblingItemsVisible {
                    ForEach(Array(0..<config.leadingItems.count).map { $0 }, id: \.hashValue) { _ in
                        Text("")
                    }
                }

                ForEach(availableItems) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VStack(spacing: config.itemContentSpacing) {
                            Text(item.description)
                                .font(config.itemFont)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity)
                            content(item, config)
                        }
                        .padding(CXSpacing.oneX)
                        .background(backgroundColor(for: item))
                    }
                    .disabled(config.isDisabled(for: item))
                    .clipShape(config.itemShape)
                    .tint(foregroundColor(for: item))
                }
                .monospacedDigit()
            }
        }
    }

    // MARK: - Private methods

    private func backgroundColor(for item: DateComponent) -> Color {
        if selectedItem == item {
            return config.itemSelectedBackgroundColor
        } else if config.isDisabled(for: item) {
            return config.itemDisabledBackgroundColor
        } else {
            return config.itemBackgroundColor
        }
    }

    private func foregroundColor(for item: DateComponent) -> Color {
        if selectedItem == item {
            return config.itemSelectedForegroundColor
        } else if isSecondary(for: item) {
            return config.itemSecondaryForegroundColor
        } else {
            return config.itemForegroundColor
        }
    }

    private func isSecondary(for item: DateComponent) -> Bool {
        config.leadingItems.contains(item) || config.trailingItems.contains(item)
    }
 }

@available(iOS 16.0, *)
#Preview {
    CXDatePicker(config: .year(years: 2020..<2025), selectedItem: .constant(.init(2021)))
}

@available(iOS 16.0, *)
#Preview {
    CXDatePicker(config: .months(year: 2024), selectedItem: .constant(.empty))
}

@available(iOS 16.0, *)
#Preview {
    CXDatePicker(config: .days(from: .now), selectedItem: .constant(.empty))
}
