//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data owned by me
    @State private var game = CodeBreaker(pegChoices: CodeBreaker.colorChoices,
                                          pegLength: 4)
    @State private var selection: Int = 0

    // MARK: States for animations
    @State private var resetting = false
    @State private var hideMostRecentMarkers = false

    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode) {
                Button("Reset", systemImage: "arrow.circlepath", action: resetGame)
                    .labelStyle(.iconOnly)
                    .flexibleSystemFont(min: ResetButton.minimumFontSize,
                                        max: ResetButton.maximumFontSize)
            }
            .animation(nil, value: game.attempts.count)

            Divider()

            ScrollView {
                if !game.isOver || resetting {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guessCode)
                            .flexibleSystemFont(min: GuessButton.minimumFontSize,
                                                max: GuessButton.maximumFontSize)
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(resetting ? 0 : 1)
                }

                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        let showMarkers = !hideMostRecentMarkers || index != game.attempts.count - 1
                        if showMarkers, let matches = game.attempts[index].matches {
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
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }

    private func resetGame() {
        withAnimation(.reset) {
            resetting = true
        } completion: {
            withAnimation(.reset) {
                game.resetGame()
                selection = 0
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

    private struct ResetButton {
        static let minimumFontSize: CGFloat = 4
        static let maximumFontSize: CGFloat = 40
        static let scaleFactor: CGFloat = 0.1
    }
}

#Preview {
    CodeBreakerView()
}
