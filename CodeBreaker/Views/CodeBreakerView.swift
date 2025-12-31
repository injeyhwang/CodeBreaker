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
        VStack(spacing: 20) {
            view(for: game.masterCode)
            view(for: game.guess)
            Divider()
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        view(for: game.attempts[index])
                    }
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
        }
        .padding()
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

    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, selection: $selection)
            Rectangle()
                .foregroundStyle(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkersView(matches: matches)
                    } else {
                        if code.kind == .master(isHidden: true) {
                            resetButton
                        } else if code.kind == .guess {
                            guessButton
                        }
                    }
                }
        }
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
