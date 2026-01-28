//
//  GameChoiceView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/12/26.
//

import SwiftUI

struct GameChoiceView: View {
    let game: CodeBreaker

    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.title)
            PegChooserView(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(
        name: "Mastermind",
        pegChoices: .masterMindPegs
    )
    List {
        GameChoiceView(game: game)
    }
    List {
        GameChoiceView(game: game)
    }
    .listStyle(.plain)
}
