//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code]
    let pegChoices: [Peg]

    init(pegChoices: [Peg] = [.red, .green, .blue, .yellow],
         pegLength: Int = 4) {
        self.masterCode = Code(kind: .master, length: pegLength)
        self.masterCode.randomize(from: pegChoices)
        self.guess = Code(kind: .guess, length: pegLength)
        self.attempts = [Code]()
        self.pegChoices = pegChoices
    }

    mutating func attemptGuess() {
        /// Ignore attempts where no pegs are chosen
        if guess.pegs.contains(Code.missing) { return }

        /// Ignore same attempts already made
        for attempt in attempts {
            if guess.pegs == attempt.pegs { return }
        }

        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }

    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        guard let choicesIndex = pegChoices.firstIndex(of: existingPeg) else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
            return
        }

        let nextIndex = (choicesIndex + 1) % pegChoices.count
        let newPeg = pegChoices[nextIndex]
        guess.pegs[index] = newPeg
    }
}

struct Code {
    static let missing: Peg = .clear

    var kind: Kind
    var pegs: [Peg]

    init(kind: Kind = .unknown, length: Int = 4) {
        self.kind = kind
        pegs = [Peg](repeating: Code.missing, count: length)
    }

    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }

    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }

    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }

    func match(against otherCode: Code) -> [Match] {
        var results = [Match](repeating: .nomatch, count: pegs.count)

        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index && pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }

        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }

        return results
    }
}
