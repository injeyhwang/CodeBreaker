//
//  GameListView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/14/26.
//

import SwiftUI

struct GameListView: View {
    // MARK: Data shared by me
    @Binding var selection: CodeBreaker?

    // MARK: Data owned by me
    @State private var games = [CodeBreaker].allGames

    // MARK: - Body
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameChoiceView(game: game)
                }
                .contextMenu {
                    deleteButton(for: game)
                }
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove { from, to in
                games.move(fromOffsets: from, toOffset: to)
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .toolbar {
            addButton()
        }
    }

    @ViewBuilder
    private func addButton() -> some View {
        Button("Add game", systemImage: "plus") {
            withAnimation {
                let newGame = CodeBreaker(
                    name: "Untitled",
                    pegChoices: [.blue, .red],
                    pegLength: 2
                )
                games.append(newGame)
            }
        }
    }

    @ViewBuilder
    private func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameListView(selection: $selection)
    }
}
