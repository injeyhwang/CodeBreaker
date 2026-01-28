//
//  GameListView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/14/26.
//

import SwiftData
import SwiftUI

struct GameListView: View {
    @Binding var selection: CodeBreaker?
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CodeBreaker.name, order: .forward) private var games: [CodeBreaker]
    @State private var gameToEdit: CodeBreaker?

    init(
        sortBy: SortOption = .name,
        nameContains search: String = "",
        selection: Binding<CodeBreaker?>
    ) {
        _selection = selection

        let lowercasedSearch = search.lowercased()
        let capitalizedSearch = search.capitalized

        let predicate = #Predicate<CodeBreaker> { game in
            search.isEmpty
            || game.name.contains(search)
            || game.name.contains(lowercasedSearch)
            || game.name.contains(capitalizedSearch)
        }
        _games = switch sortBy {
        case .name: Query(filter: predicate, sort: \CodeBreaker.name)
        case .recent: Query(
            filter: predicate,
            sort: \CodeBreaker.lastAttemptDate,
            order: .reverse
        )
        }
    }

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
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .listStyle(.plain)
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .toolbar {
            EditButton()
            addButton()
        }
        .onAppear { addSampleGames() }
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
                    if games.contains(gameToEdit) {
                        modelContext.delete(gameToEdit)
                    }

                    modelContext.insert(copyOfGameToEdit)
                }
            }
        }
    }

    private func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }

    private func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            withAnimation {
                gameToEdit = game
            }
        }
    }

    private func addSampleGames() {
        let descriptor = FetchDescriptor<CodeBreaker>()
        if let count = try? modelContext.fetchCount(descriptor), count == 0 {
            modelContext.insert(CodeBreaker.mastermindGame)
            modelContext.insert(CodeBreaker.earthTonesGame)
            modelContext.insert(CodeBreaker.underSeaGame)
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameListView(selection: $selection)
    }
}
