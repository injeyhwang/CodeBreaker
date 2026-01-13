//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/9/26.
//

import SwiftUI

struct GameChooserView: View {
    // MARK: Data owned by me
    @State private var games = [CodeBreaker].allGames

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameChoiceView(game: game)
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { from, to in
                    games.move(fromOffsets: from, toOffset: to)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { value in
                CodeBreakerView(game: value)
            }
            .navigationTitle("Code Breaker")
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    GameChooserView()
}
