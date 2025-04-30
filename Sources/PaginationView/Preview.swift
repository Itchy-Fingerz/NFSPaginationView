//
//  Preview.swift
//  PaginationView
//
//  Created by Ali Khitran on 28/04/2025.
//
import SwiftUI

struct PaginationPreview: View {
    @StateObject private var viewModel = PaginationViewModel(totalPages: 10)

    var body: some View {
        PaginationView(
            viewModel: viewModel,
            config: PaginationConfiguration(
                leftArrowImage: Image(systemName: "arrow.left.circle.fill"),
                rightArrowImage: Image(systemName: "arrow.right.circle.fill"),
                backgroundColor: .white,
                selectedColor: .green,
                unselectedColor: .gray.opacity(0.5),
                textColor: .black
            )
        ) { page in
            print("Page selected: \(page)")
        }
        .padding()
    }
}


#Preview {
    PaginationPreview()
}
