//
//  GameListView+SortOption.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/27/26.
//

import Foundation

extension GameListView {
    enum SortOption: CaseIterable {
        case name
        case recent

        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            }
        }
    }
}
