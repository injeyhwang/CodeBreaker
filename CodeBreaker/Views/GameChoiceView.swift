//
//  GameChoiceView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/12/26.
//

import SwiftUI

struct GameChoiceView: View {
    let game: CodeBreaker
    let size: Size

    init(game: CodeBreaker, size: Size = .large) {
        self.game = game
        self.size = size
    }

    var body: some View {
        layout {
            Text(game.name)
                .font(getGameTitleSize)
            PegChooserView(choices: game.pegChoices)
                .frame(maxHeight: getPegChoicesSize)
            if size == .large {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
    }

    private var layout: AnyLayout {
        switch size {
            case .compact: return AnyLayout(HStackLayout())
        default: return AnyLayout(VStackLayout(alignment: .leading))
        }
    }

    private var getGameTitleSize: Font {
        switch size {
        case .compact: return .body
        default: return .title
        }
    }

    private var getPegChoicesSize: CGFloat {
        switch size {
        case .compact: return 25
        case .regular: return 35
        default: return 50
        }
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(
        name: "Mastermind",
        pegChoices: .masterMindPegs
    )
    List {
        GameChoiceView(game: game, size: .compact)
        GameChoiceView(game: game, size: .regular)
        GameChoiceView(game: game)
    }
    .listStyle(.plain)
}
