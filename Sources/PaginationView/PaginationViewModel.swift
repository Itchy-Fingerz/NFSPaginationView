//
//  PaginationViewModel.swift
//  paginationViewEgUIkit+SwiftUI
//
//  Created by Ali Khitran on 28/04/2025.
//

import SwiftUI
import Combine

@objcMembers
public class PaginationViewModel: ObservableObject {
    @Published public var currentPage: Int = 1
    public let totalPages: Int

    public init(totalPages: Int) {
        self.totalPages = totalPages
    }
}
