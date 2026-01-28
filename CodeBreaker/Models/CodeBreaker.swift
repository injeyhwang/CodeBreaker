//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

import SwiftData
import Foundation

@Model
class CodeBreaker {
    var name: String
    var pegChoices: [Peg]
    @Relationship(deleteRule: .cascade) var masterCode: Code
    @Relationship(deleteRule: .cascade) var guess: Code
    @Relationship(deleteRule: .cascade) var _attempts = [Code]()
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver: Bool = false

    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp }}
        set { _attempts = newValue }
    }

    init(name: String, pegChoices: [Peg]) {
        self.name = name
        self.pegChoices = pegChoices

        let masterCodeLength = Int.random(in: 3...6)
        masterCode = Code(
            kind: .master(isHidden: true),
            length: masterCodeLength
        )
        guess = Code(kind: .guess, length: masterCodeLength)

        // Randomize master code from available peg choices
        masterCode.randomize(from: pegChoices)
    }

    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }

    func startTimer() {
        if startTime == nil && !isOver {
            startTime = .now
            elapsedTime += 0.00001
        }
    }

    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }

        startTime = nil
    }

    func resetGame() {
        let masterCodeLength = Int.random(in: 3...6)
        masterCode = Code(
            kind: .master(isHidden: true),
            length: masterCodeLength
        )
        masterCode.randomize(from: pegChoices)
        guess.reset(with: masterCodeLength)
        attempts.removeAll()

        // Reset timer
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }

    func attemptGuess() -> Bool {
        // Ignore attempts where no pegs are chosen
        guard !guess.pegs.contains(Peg.missing) else { return false }

        // Ignore same attempts already made
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else {
            guess.reset(with: guess.pegs.count)
            return false
        }

        let matches = guess.match(against: masterCode)
        let attempt = Code(kind: .attempt(matches), length: guess.pegs.count)
        attempt.pegs = guess.pegs
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now

        // Clear guess
        guess.reset(with: guess.pegs.count)

        // Reveal master code when the game is over
        if attempts.first?.pegs == masterCode.pegs {
            isOver = true
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
