//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

import SwiftUI

struct CodeBreaker {
    static let defaultChoices = ["red", "green", "blue", "yellow"]
    static let earthChoices = ["orange", "brown", "black", "gray"]
    static let blueChoices = ["blue", "indigo", "cyan"]
    static let flagEmojiChoices = ["🇰🇷", "🇨🇦", "🇺🇸", "🇬🇧"]
    static let faceEmojiChoices = ["😊", "🤣", "😂", "😭", "🥰"]

    static let allPegChoices = [
        Self.defaultChoices,
        Self.earthChoices,
        Self.blueChoices,
        Self.faceEmojiChoices,
        Self.flagEmojiChoices
    ]

    var pegChoices: [Peg]
    var masterCode: Code
    var guess: Code
    var attempts: [Code]
    var startTime: Date = .now
    var endTime: Date?

    init(pegChoices: [Peg], pegLength: Int) {
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
        attempts.last?.pegs == masterCode.pegs
    }

    mutating func resetGame() {
        let pegChoices = Self.allPegChoices.randomElement() ?? Self.colorChoices
        let pegLength = Int.random(in: 3...6)

        self = .init(pegChoices: pegChoices, pegLength: pegLength)
    }

    mutating func attemptGuess() {
        // Ignore attempts where no pegs are chosen
        if guess.pegs.contains(Peg.missing) { return }

        // Ignore same attempts already made
        for attempt in attempts {
            if guess.pegs == attempt.pegs {
                guess.reset()
                return
            }
        }

        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)

        // Clear guess
        guess.reset()

        // Reveal master code when the game is over
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }

    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        
        guess.pegs[index] = peg
    }
}
