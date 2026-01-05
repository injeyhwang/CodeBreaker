//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data owned by me
    @State private var game = CodeBreaker(
        pegChoices: CodeBreaker.colorChoices,
        pegLength: 4
    )
    @State private var selection: Int = 0

    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode) {
                resetButton
            }
            Divider()
            if !game.isGameOver {
                CodeView(code: game.guess, selection: $selection) {
                    guessButton
                }
            }
            ScrollView {
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        if let matches = game.attempts[index].matches {
                            MatchMarkersView(matches: matches)
                        }
                    }
                }
            }
            PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
        }
        .padding()
    }

    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }

    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }

    var resetButton: some View {
        Button("Reset") {
            withAnimation {
                game.resetGame()
            }
        }
        .font(.system(size: ResetButton.maximumFontSize))
        .minimumScaleFactor(ResetButton.scaleFactor)
    }

    private struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = 0.1
    }

    private struct ResetButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = 0.1
    }
}

#Preview {
    CodeBreakerView()
}
