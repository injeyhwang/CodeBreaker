//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data owned by me
    @State private var game = CodeBreaker(pegChoices: CodeBreaker.defaultChoices,
                                          pegLength: 4)
    @State private var selection: Int = 0

    // MARK: States for animations
    @State private var resetting = false
    @State private var hideMostRecentMarkers = false

    // MARK: - Body
    var body: some View {
        Button("Reset", systemImage: "arrow.circlepath", action: resetGame)

        VStack {
            CodeView(code: game.masterCode) {
                TimerView(startTime: game.startTime, endTime: game.endTime)
                    .flexibleSystemFont()
                    .monospaced()
                    .lineLimit(1)
            }
            .animation(nil, value: game.attempts.count)

            Divider()

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
    CodeBreakerView()
}
