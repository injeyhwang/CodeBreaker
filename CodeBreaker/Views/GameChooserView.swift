//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/9/26.
//

import SwiftUI

struct GameChooserView: View {
    // MARK: Data owned by me
    @State private var games = [CodeBreaker]()

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List($games, id: \.pegChoices) { $game in
                NavigationLink {
                    CodeBreakerView(game: $game)
                } label: {
                    GameChoiceView(game: game)
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind",
                                     pegChoices: CodeBreaker.defaultChoices,
                                     pegLength: CodeBreaker.defaultChoices.count))
            games.append(CodeBreaker(name: "Earth Tones",
                                     pegChoices: CodeBreaker.earthChoices,
                                     pegLength: CodeBreaker.earthChoices.count))
            games.append(CodeBreaker(name: "Undersea",
                                     pegChoices: CodeBreaker.blueChoices,
                                     pegLength: CodeBreaker.blueChoices.count))
        }
    }
}

#Preview {
    GameChooserView()
}
