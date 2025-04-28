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
        VStack {
            PaginationView(viewModel: viewModel) { page in
                print("Page selected: \(page)")
            }
            .padding()
            .previewLayout(.sizeThatFits)
            .frame(width: 300)
        }
    }
}


#Preview {
    PaginationPreview()
}
