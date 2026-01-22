//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/9/26.
//

import SwiftUI

struct GameChooserView: View {
    @State private var selection: CodeBreaker? = nil

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameListView(selection: $selection)
                .navigationTitle("Code Breaker")
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

#Preview {
    GameChooserView()
}
