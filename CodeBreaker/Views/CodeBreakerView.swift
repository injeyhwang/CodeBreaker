//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data shared with me
    @Binding var game: CodeBreaker

    // MARK: Data owned by me
    @State private var selection: Int = 0
    @State private var resetting = false
    @State private var hideMostRecentMarkers = false

    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
                .animation(nil, value: game.attempts.count)

            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guessCode)
                            .flexibleSystemFont(min: GuessButton.minimumFontSize,
                                                max: GuessButton.maximumFontSize)
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(resetting && game.isOver ? 0 : 1)
                }

                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers, let matches = attempt.matches {
                            MatchMarkersView(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }

            if !game.isOver {
                PegChooserView(choices: game.pegChoices,
                               onChoose: changeSelectedPeg)
                .transition(.pegChooser)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Reset", systemImage: "arrow.circlepath", action: resetGame)
            }
            ToolbarItem(placement: .automatic) {
                TimerView(startTime: game.startTime, endTime: game.endTime)
                    .monospaced()
                    .lineLimit(1)
                    .padding()
            }
        }
        .padding()
    }

    private func guessCode() {
        withAnimation(.guess) {
            if game.attemptGuess() {
                selection = 0
                hideMostRecentMarkers = true
            }
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }

    private func resetGame() {
        withAnimation(.reset) {
            resetting = game.isOver
            game.resetGame()
            selection = 0
        } completion: {
            withAnimation(.reset) {
                resetting = false
            }
        }
    }

    private func changeSelectedPeg(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }

    private struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = 0.1
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(
        name: "Default",
        pegChoices: CodeBreaker.defaultChoices,
        pegLength: CodeBreaker.defaultChoices.count
    )

    NavigationStack {
        CodeBreakerView(game: $game)
    }
}
