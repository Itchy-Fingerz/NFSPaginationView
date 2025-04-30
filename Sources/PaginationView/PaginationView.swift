//
//  PaginationView.swift
//  paginationView
//
//  Created by Ali Khitran on 28/04/2025.
//

import SwiftUI

public enum PageItem: Equatable {
    case number(Int)
    case ellipsis
}

public struct PaginationConfiguration {
    public let leftArrowImage: Image
    public let rightArrowImage: Image

    public let backgroundColor: Color
    public let selectedColor: Color
    public let unselectedColor: Color
    public let textColor: Color

    public init(
        leftArrowImage: Image = Image(systemName: "chevron.left"),
        rightArrowImage: Image = Image(systemName: "chevron.right"),
        backgroundColor: Color = .white,
        selectedColor: Color = .green,
        unselectedColor: Color = .gray,
        textColor: Color = .black
    ) {
        self.leftArrowImage = leftArrowImage
        self.rightArrowImage = rightArrowImage
        self.backgroundColor = backgroundColor
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.textColor = textColor
    }
}


public struct PaginationView: View {
    @ObservedObject var viewModel: PaginationViewModel
    var onPageSelected: ((Int) -> Void)?
    var config: PaginationConfiguration

    private var paginationItems: [PageItem] {
        generatePaginationItems(currentPage: viewModel.currentPage, totalPages: viewModel.totalPages)
    }

    public init(
        viewModel: PaginationViewModel,
        config: PaginationConfiguration = PaginationConfiguration(),
        onPageSelected: ((Int) -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.config = config
        self.onPageSelected = onPageSelected
    }

    public var body: some View {
        GeometryReader { geometry in
            
            HStack(spacing: 12) {
                
                // Left
                Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(config.textColor)
                
                Spacer()
                
                // Center
                HStack(spacing: 8) {
                    Button(action: previousPage) {
                        HStack {
                            config.leftArrowImage
                            Text("Previous")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(viewModel.currentPage == 1 ? config.unselectedColor : config.selectedColor)
                    }
                    .disabled(viewModel.currentPage == 1)
                    
                    ForEach(Array(paginationItems.enumerated()), id: \.offset) { _, item in
                        switch item {
                        case .number(let page):
                            Text("\(page)")
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: 32, height: 32)
                                .background(viewModel.currentPage == page ? config.selectedColor : Color.clear)
                                .foregroundColor(viewModel.currentPage == page ? config.backgroundColor : config.textColor)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectPage(page)
                                }
                            
                        case .ellipsis:
                            Text("...")
                                .font(.system(size: 14))
                                .foregroundColor(config.unselectedColor)
                                .frame(width: 32, height: 32)
                        }
                    }
                    
                    Button(action: nextPage) {
                        HStack {
                            Text("Next")
                                .font(.system(size: 14, weight: .medium))
                            config.rightArrowImage
                        }
                        .foregroundColor(viewModel.currentPage == viewModel.totalPages ? config.unselectedColor : config.selectedColor)
                    }
                    .disabled(viewModel.currentPage == viewModel.totalPages)
                }
                
                Spacer()
                
                // Right
                Picker("Page", selection: $viewModel.currentPage) {
                    ForEach(1...viewModel.totalPages, id: \.self) { page in
                        Text("Page \(page)").tag(page)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100)
                .foregroundColor(config.textColor)
                .background(config.backgroundColor.opacity(0.6))
                .cornerRadius(8)

            }
            .background(config.backgroundColor)
        }
    }
    
    private struct PageSelectorMenu: View {
        @Binding var currentPage: Int
        let totalPages: Int
        let config: PaginationConfiguration
        let onPageSelected: ((Int) -> Void)?

        var body: some View {
            HStack(spacing: 8) {
                // Left: Label
                Text("Page")
                    .foregroundColor(config.textColor)
                    .font(.system(size: 16, weight: .medium))

                // Right: Dropdown
                Menu {
                    ForEach(1...totalPages, id: \.self) { page in
                        Button(action: {
                            currentPage = page
                            onPageSelected?(page)
                        }) {
                            HStack {
                                Text("\(page)")
                                    .fontWeight(currentPage == page ? .bold : .regular)
                                if currentPage == page {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(config.selectedColor)
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("\(currentPage)")
                            .foregroundColor(config.textColor)
                            .font(.system(size: 16, weight: .semibold))

                        Image(systemName: "chevron.down")
                            .resizable()
                            .frame(width: 10, height: 6)
                            .foregroundColor(config.textColor)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(config.unselectedColor)
                    )
                    .cornerRadius(8)
                }
            }
        }
    }




    private func selectPage(_ page: Int) {
        viewModel.currentPage = page
        onPageSelected?(page)
    }

    private func previousPage() {
        guard viewModel.currentPage > 1 else { return }
        viewModel.currentPage -= 1
        onPageSelected?(viewModel.currentPage)
    }

    private func nextPage() {
        guard viewModel.currentPage < viewModel.totalPages else { return }
        viewModel.currentPage += 1
        onPageSelected?(viewModel.currentPage)
    }

    private func generatePaginationItems(currentPage: Int, totalPages: Int) -> [PageItem] {
        var items: [PageItem] = []

        if totalPages <= 7 {
            for page in 1...totalPages {
                items.append(.number(page))
            }
        } else {
            if currentPage <= 4 {
                for page in 1...5 {
                    items.append(.number(page))
                }
                items.append(.ellipsis)
                items.append(.number(totalPages))
            } else if currentPage >= totalPages - 3 {
                items.append(.number(1))
                items.append(.ellipsis)
                for page in (totalPages-4)...totalPages {
                    items.append(.number(page))
                }
            } else {
                items.append(.number(1))
                items.append(.ellipsis)
                items.append(.number(currentPage - 1))
                items.append(.number(currentPage))
                items.append(.number(currentPage + 1))
                items.append(.ellipsis)
                items.append(.number(totalPages))
            }
        }

        return items
    }
}
