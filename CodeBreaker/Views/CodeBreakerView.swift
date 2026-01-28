//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct CodeBreakerView: View {
    let game: CodeBreaker
    @State private var selection = 0
    @State private var resetting = false
    @State private var hideMostRecentMarkers = false

    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
                .animation(nil, value: game.attempts.count)

            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guessCode)
                            .flexibleSystemFont(min: GuessButton.minFontSize,
                                                max: GuessButton.maxFontSize)
                            .lineLimit(1)
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
        .trackElapsedTime(for: game)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Reset", systemImage: "arrow.circlepath", action: resetGame)
            }
            ToolbarItem(placement: .automatic) {
                TimerView(startTime: game.startTime,
                          endTime: game.endTime,
                          elapsedTime: game.elapsedTime)
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
}

extension CodeBreakerView {
    private enum GuessButton {
        static let minFontSize: CGFloat = 8
        static let maxFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = 0.1
    }
}

extension View {
    func trackElapsedTime(for game: CodeBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

private struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    let game: CodeBreaker

    func body(content: Content) -> some View {
        content
            .onAppear { game.startTimer() }
            .onDisappear { game.pauseTimer() }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker.mastermindGame
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
