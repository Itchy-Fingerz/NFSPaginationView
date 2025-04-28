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

@objcMembers
public struct PaginationView: View {
    @ObservedObject var viewModel: PaginationViewModel
    var onPageSelected: ((Int) -> Void)? = nil

    private var paginationItems: [PageItem] {
        generatePaginationItems(currentPage: viewModel.currentPage, totalPages: viewModel.totalPages)
    }

    public init(viewModel: PaginationViewModel, onPageSelected: @escaping (Int) -> Void) {
        self.viewModel = viewModel
        self.onPageSelected = onPageSelected
    }

    public var body: some View {
        HStack(spacing: 12) {
            // Left: Page label
            Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            // Center: Pagination buttons with arrows and page numbers
            HStack(spacing: 8) {
                Button(action: previousPage) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(viewModel.currentPage == 1 ? Color.gray : Color.white)
                }
                .disabled(viewModel.currentPage == 1)

                ForEach(Array(paginationItems.enumerated()), id: \.offset) { index, item in
                    switch item {
                    case .number(let page):
                        Text("\(page)")
                            .font(.system(size: 14, weight: .medium))
                            .frame(width: 32, height: 32)
                            .background(viewModel.currentPage == page ? Color(white: 0.3) : Color.clear)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectPage(page)
                            }

                    case .ellipsis:
                        Text("...")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .frame(width: 32, height: 32)
                    }
                }

                Button(action: nextPage) {
                    HStack {
                        Text("Next")
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(viewModel.currentPage == viewModel.totalPages ? Color.gray : Color.white)
                }
                .disabled(viewModel.currentPage == viewModel.totalPages)
            }

            Spacer()

            // Right: Page dropdown picker
            Picker("Page", selection: $viewModel.currentPage) {
                ForEach(1...viewModel.totalPages, id: \.self) { page in
                    Text("Page \(page)").tag(page)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 100) // Adjust the width as needed
            .foregroundColor(.white)
            .background(Color.black.opacity(0.5))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(12)
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
