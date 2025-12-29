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
        VStack {
            view(for: game.masterCode)
            Divider()
                .padding(.vertical)
            view(for: game.guess)
            Divider()
                .padding(.vertical)
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
                game = CodeBreaker(pegLength: .random(in: 3...6))
            }
        }
    }

    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .master {
                        resetButton
                    } else if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
