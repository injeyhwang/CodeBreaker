//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

import SwiftUI

struct CodeBreaker {
    static let colorChoices = ["red", "green", "blue", "yellow"]
    static let flagEmojiChoices = ["🇰🇷", "🇨🇦", "🇺🇸", "🇬🇧"]
    static let faceEmojiChoices = ["😊", "🤣", "😂", "😭", "🥰"]

    var masterCode: Code
    var guess: Code
    var attempts: [Code]
    let pegChoices: [Peg]
    let pegLength: Int

    init(pegChoices: [Peg] = Self.colorChoices,
         pegLength: Int = Self.colorChoices.count) {
        self.masterCode = Code(kind: .master, length: pegLength)
        self.masterCode.randomize(from: pegChoices)
        self.guess = Code(kind: .guess, length: pegLength)
        self.attempts = [Code]()
        self.pegChoices = pegChoices
        self.pegLength = pegLength
    }

    mutating func attemptGuess() {
        /// Ignore attempts where no pegs are chosen
        if guess.pegs.contains(Peg.missing) { return }

        /// Ignore same attempts already made
        for attempt in attempts {
            if guess.pegs == attempt.pegs { return }
        }

        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)

        /// Clear guess
        self.guess = Code(kind: .guess, length: pegLength)
    }

    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        guard let choicesIndex = pegChoices.firstIndex(of: existingPeg) else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
            return
        }

        let nextIndex = (choicesIndex + 1) % pegChoices.count
        let newPeg = pegChoices[nextIndex]
        guess.pegs[index] = newPeg
    }

    static func getGameChoices() -> [Peg] {
        let gameChoices = [
            Self.colorChoices,
            Self.faceEmojiChoices,
            Self.flagEmojiChoices
        ]

        if let choices = gameChoices.randomElement() {
            return choices
        }

        return Self.colorChoices
    }
}
