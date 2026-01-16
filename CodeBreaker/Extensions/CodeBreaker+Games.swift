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
        pegChoices: .masterMindPegs
    )

    static let earthTonesGame = CodeBreaker(
        name: "Earth Tones",
        pegChoices: .earthTonesPegs
    )

    static let underSeaGame = CodeBreaker(
        name: "Undersea",
        pegChoices: .underSeaPegs
    )
}

extension [CodeBreaker] {
    static let allGames: [CodeBreaker] = [
        .mastermindGame,
        .earthTonesGame,
        .underSeaGame
    ]
}
