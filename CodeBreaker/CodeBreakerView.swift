//
//  ContentView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker()

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
        .frame(width: 50)
    }

    var resetButton: some View {
        Button("Reset") {
            withAnimation {
                game = CodeBreaker(pegChoices: CodeBreaker.getGameChoices(),
                                   pegLength: .random(in: 3...6))
            }
        }
        .frame(width: 50)
    }

    func view(for code: Code) -> some View {
        HStack {
            HStack {
                ForEach(code.pegs.indices, id: \.self) { index in
                    ZStack {
                        if code.pegs[index] == Code.missing {
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
            }

            if code.kind == .master {
                resetButton
            } else if code.kind == .guess {
                guessButton
            } else {
                MatchMarkers(matches: code.matches)
            }
        }
    }
}

#Preview {
    CodeBreakerView()
}
