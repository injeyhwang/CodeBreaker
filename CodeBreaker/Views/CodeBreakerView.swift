//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct CodeBreakerView: View {
    @State private var game = CodeBreaker()

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
        }
        .padding()
    }

    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }

    var resetButton: some View {
        Button("Reset") {
            withAnimation {
                game = CodeBreaker(pegChoices: CodeBreaker.getGameChoices(),
                                   pegLength: .random(in: 3...6))
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }

    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                ZStack {
                    if code.pegs[index] == Peg.missing {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    }

                    if let colorized = code.pegs[index].colorize {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(colorized)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.gray)
                            .foregroundStyle(.clear)
                        Text(code.pegs[index])
                            .font(.largeTitle)
                    }
                }
                .contentShape(Rectangle())
                .aspectRatio(1, contentMode: .fit)
                .onTapGesture {
                    if code.kind == .guess {
                        game.changeGuessPeg(at: index)
                    }
                }
            }

            Rectangle()
                .foregroundStyle(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkersView(matches: matches)
                    } else {
                        if code.kind == .master {
                            resetButton
                        } else if code.kind == .guess {
                            guessButton
                        }
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
