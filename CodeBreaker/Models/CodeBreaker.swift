//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

import SwiftUI

@Observable class CodeBreaker {
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
        guess = Code(kind: .guess, length: pegLength)
        attempts = [Code]()

        // Randomize master code from available peg choices
        masterCode.randomize(from: pegChoices)

        // Reset timer
        startTime = .now
        endTime = nil
    }

    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }

    func resetGame() {
        let pegLength = Int.random(in: 3...6)
        masterCode = Code(kind: .master(isHidden: true), length: pegLength)
        guess = Code(kind: .guess, length: pegLength)
        attempts = [Code]()

        // Randomize master code from available peg choices
        masterCode.randomize(from: pegChoices)

        // Reset timer
        startTime = .now
        endTime = nil
    }

    func attemptGuess() -> Bool {
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

    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }

        guess.pegs[index] = peg
    }
}
