//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/9/26.
//

import SwiftUI

struct GameChooserView: View {
    @State private var selection: CodeBreaker? = nil
    @State private var sortOption: GameListView.SortOption = .name
    @State private var search: String = ""

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameListView.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameListView(
                sortBy: sortOption,
                nameContains: search,
                selection: $selection
            )
            .navigationTitle("Code Breaker")
            .searchable(text: $search)
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview(traits: .swiftData) {
    GameChooserView()
}
