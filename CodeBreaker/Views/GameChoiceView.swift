//
//  GameChoiceView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/12/26.
//

import SwiftUI

struct GameChoiceView: View {
    // MARK: Data in
    let game: CodeBreaker

    // MARK: - Body
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
    let defaultGame = CodeBreaker(name: "Default",
                                  pegChoices: CodeBreaker.defaultChoices,
                                  pegLength: CodeBreaker.defaultChoices.count)
    List {
        GameChoiceView(game: defaultGame)
    }
    List {
        GameChoiceView(game: defaultGame)
    }
    .listStyle(.plain)
}
