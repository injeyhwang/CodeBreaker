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
    var attempts = [Code]()
    var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0

    init(name: String, pegChoices: [Peg]) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode = Code(kind: .master(isHidden: true), length: pegChoices.count)
        guess = Code(kind: .guess, length: pegChoices.count)

        // Randomize master code from available peg choices
        masterCode.randomize(from: pegChoices)
    }

    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }

    func startTimer() {
        if startTime == nil && !isOver {
            startTime = .now
        }
    }

    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }

        startTime = nil
    }

    func resetGame() {
        let pegLength = Int.random(in: 3...6)
        masterCode = Code(kind: .master(isHidden: true), length: pegLength)
        masterCode.randomize(from: pegChoices)
        guess.reset(with: masterCodeLength)
        attempts.removeAll()

        // Reset timer
        startTime = .now
        endTime = nil
        elapsedTime = 0
    }

    func attemptGuess() -> Bool {
        // Ignore attempts where no pegs are chosen
        guard !guess.pegs.contains(Peg.missing) else { return false }

        // Ignore same attempts already made
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else {
            guess.reset(with: guess.pegs.count)
            return false
        }

        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)

        // Clear guess
        guess.reset(with: guess.pegs.count)

        // Reveal master code when the game is over
        if isOver {
            endTime = .now
            masterCode.kind = .master(isHidden: false)
            pauseTimer()
        }

        return true
    }

    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }

        guess.pegs[index] = peg
    }
}
