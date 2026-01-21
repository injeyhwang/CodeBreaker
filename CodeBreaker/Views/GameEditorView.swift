//
//  GameEditorView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/15/26.
//

import SwiftUI

struct GameEditorView: View {
    // MARK: Data shared by me
    @Bindable var game: CodeBreaker

    // MARK: Data in
    @Environment(\.dismiss) var dismiss
    let onSubmit: () -> Void

    // MARK: Data owned by me
    @State private var showInvalidGameAlert = false

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section("Game Name") {
                    TextField("MasterMind", text: $game.name)
                        .autocapitalization(.words)
                        .autocorrectionDisabled()
                        .onSubmit(done)
                }
                Section("Peg Choices") {
                    PegChoicesChooserView(pegChoices: $game.pegChoices)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    submitButton()
                }
            }
        }
    }

    private func submitButton() -> some View {
        Button("Submit", action: done)
            .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                Button("OK") { showInvalidGameAlert = false }
            } message: {
                Text("A game must have a name and at least two pegs with no duplicates.")
            }
    }

    private func done() {
        guard game.isValid else {
            showInvalidGameAlert = true
            return
        }

        onSubmit()
        dismiss()
    }
}

private extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && pegChoices.areUnique && pegChoices.areAtLeastTwo
    }
}

private extension [Peg] {
    var areAtLeastTwo: Bool {
        self.count >= 2
    }

    var areUnique: Bool {
        Set(self).count == self.count
    }
}

#Preview {
    @Previewable var game = CodeBreaker(
        name: "Preview",
        pegChoices: [.red, .blue]
    )
    GameEditorView(game: game) { print("onSubmit called") }
        .onChange(of: game.name) {
            print("Game name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("Game peg choices changed to \(game.pegChoices)")
        }
}
