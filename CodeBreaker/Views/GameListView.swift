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
    @State private var gameToEdit: CodeBreaker?

    // MARK: - Body
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameChoiceView(game: game)
                }
                .contextMenu {
                    editButton(for: game)
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game)
                        .tint(.accentColor)
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
            EditButton()
            addButton()
        }
    }

    private var showGameEditor: Binding<Bool> {
        Binding<Bool>(get: { gameToEdit != nil }, set: { newValue in
            if !newValue { gameToEdit = nil }
        })
    }

    private func addButton() -> some View {
        Button("Add Game", systemImage: "plus") {
            withAnimation {
                gameToEdit = CodeBreaker(
                    name: "Untitled",
                    pegChoices: ["red", "blue"]
                )
            }
        }
        .sheet(isPresented: showGameEditor) {
            if let gameToEdit {
                let copyOfGameToEdit = CodeBreaker(
                    name: gameToEdit.name,
                    pegChoices: gameToEdit.pegChoices
                )
                GameEditorView(game: gameToEdit) {
                    // check if gameToEdit exists in the games array
                    guard let index = games.firstIndex(of: gameToEdit) else {
                        games.insert(gameToEdit, at: 0)
                        return
                    }
                    games[index] = copyOfGameToEdit
                }
            }
        }
    }

    private func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation { games.removeAll { $0 == game } }
        }
    }

    private func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            withAnimation {
                gameToEdit = game
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
