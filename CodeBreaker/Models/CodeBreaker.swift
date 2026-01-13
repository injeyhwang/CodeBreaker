//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

import SwiftUI

struct CodeBreaker {
    static let mastermindGame = Self(
        name: "Mastermind",
        pegChoices: .masterMindPegs,
        pegLength: 4
    )

    static let earthTonesGame = Self(
        name: "Earth Tones",
        pegChoices: .earthTonesPegs,
        pegLength: 4
    )

    static let underSeaGame = Self(
        name: "Undersea",
        pegChoices: .underSeaPegs,
        pegLength: 3
    )

    var name: String
    var pegChoices: [Peg]
    var masterCode: Code
    var guess: Code
    var attempts: [Code]
    var startTime: Date = .now
    var endTime: Date?

    init(name: String, pegChoices: [Peg], pegLength: Int) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode = Code(kind: .master(isHidden: true), length: pegLength)
        masterCode.randomize(from: pegChoices)
        guess = Code(kind: .guess, length: pegLength)
        attempts = [Code]()

        // Reset timer
        startTime = .now
        endTime = nil
    }

    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }

    mutating func resetGame() {
        guard let newGame = [CodeBreaker].allGames.randomElement() else {
            fatalError("This should not happen...")
        }

        self = .init(
            name: newGame.name,
            pegChoices: newGame.pegChoices,
            pegLength: .random(in: 3...6)
        )
    }

    mutating func attemptGuess() -> Bool {
        // Ignore attempts where no pegs are chosen
        guard !guess.pegs.contains(Peg.missing) else { return false }

        // Ignore same attempts already made
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else {
            guess.reset()
            return false
        }

        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)

        // Clear guess
        guess.reset()

        // Reveal master code when the game is over
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }

        return true
    }

    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        
        guess.pegs[index] = peg
    }
}

extension [CodeBreaker] {
    static let allGames: [CodeBreaker] = [
        .mastermindGame,
        .earthTonesGame,
        .underSeaGame
    ]
}
