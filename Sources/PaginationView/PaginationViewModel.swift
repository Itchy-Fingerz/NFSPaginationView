//
//  PaginationViewModel.swift
//  paginationViewEgUIkit+SwiftUI
//
//  Created by Ali Khitran on 28/04/2025.
//

import SwiftUI
import Combine

public class PaginationViewModel: ObservableObject {
    @Published public var currentPage: Int = 1
    public var totalPages: Int

    public init(totalPages: Int) {
        self.totalPages = totalPages
    }
}
