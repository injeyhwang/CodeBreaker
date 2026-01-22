//
//  GameEditorView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/15/26.
//

import SwiftUI

struct GameEditorView: View {
    @Bindable var game: CodeBreaker
    let onSubmit: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var showInvalidGameAlert = false
    @State private var pegChoiceIndex: Int? = nil

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
                    ForEach($game.pegChoices.indices, id: \.self) { index in
                        editChoiceButton(at: index)
                    }
                    addChoiceButton()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton()
                }
                ToolbarItem(placement: .confirmationAction) {
                    submitButton()
                }
            }
            .navigationTitle("Edit Game")
            .sheet(isPresented: showPegEditor) {
                if let pegChoiceIndex {
                    PegChoiceChooserView(
                        pegChoices: $game.pegChoices,
                        pegChoiceIndex: pegChoiceIndex
                    )
                }
            }
        }
    }

    private func editChoiceButton(at index: Int) -> some View {
        Button {
            withAnimation { pegChoiceIndex = index }
        } label: {
            HStack {
                PegView(peg: game.pegChoices[index])
                    .frame(maxHeight: PegChoice.maxHeight)
                Text("Peg Choice \(index + 1)")
            }
        }
    }

    private func addChoiceButton() -> some View {
        Button {
            withAnimation { game.pegChoices.append(.missing) }
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Peg Choice")
            }
        }
    }

    private func cancelButton() -> some View {
        Button("Cancel", role: .cancel) { dismiss() }
    }

    private func submitButton() -> some View {
        Button("Submit", role: .confirm, action: done)
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

    private var showPegEditor: Binding<Bool> {
        Binding<Bool>(
            get: { pegChoiceIndex != nil },
            set: { newValue in if !newValue { pegChoiceIndex = nil } }
        )
    }
}

extension GameEditorView {
    private enum PegChoice {
        static let maxHeight: CGFloat = 18
    }
}

private extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && pegChoices.areUnique && pegChoices.areAtLeastTwo && pegChoices.hasNoMissing
    }
}

private extension [Peg] {
    var areAtLeastTwo: Bool {
        self.count >= 2
    }

    var areUnique: Bool {
        Set(self).count == self.count
    }

    var hasNoMissing: Bool {
        !self.contains(.missing)
    }
}

#Preview {
    @Previewable var game = CodeBreaker(
        name: "Preview",
        pegChoices: ["red", "blue", "green"]
    )
    GameEditorView(game: game) { print("onSubmit called") }
        .onChange(of: game.name) {
            print("Game name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("Game peg choices changed to \(game.pegChoices)")
        }
}
