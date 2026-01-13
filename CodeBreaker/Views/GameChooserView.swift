//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/9/26.
//

import SwiftUI

struct GameChooserView: View {
    // MARK: Data owned by me
    @State private var games = [CodeBreaker].allGames

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
    }
}

#Preview {
    GameChooserView()
}
