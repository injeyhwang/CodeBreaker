//
//  CodeBreaker+Games.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/13/26.
//

import SwiftUI

extension CodeBreaker {
    static let mastermindGame = CodeBreaker(
        name: "Mastermind",
        pegChoices: .masterMindPegs,
        pegLength: 4
    )

    static let earthTonesGame = CodeBreaker(
        name: "Earth Tones",
        pegChoices: .earthTonesPegs,
        pegLength: 4
    )

    static let underSeaGame = CodeBreaker(
        name: "Undersea",
        pegChoices: .underSeaPegs,
        pegLength: 3
    )
}

extension [CodeBreaker] {
    static let allGames: [CodeBreaker] = [
        .mastermindGame,
        .earthTonesGame,
        .underSeaGame
    ]
}
