//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

import SwiftUI

typealias Peg = String

extension String {
    var colorize: Color? {
        switch self.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "gray", "grey": return .gray
        case "black": return .black
        case "white": return .white
        case "cyan": return .cyan
        case "mint": return .mint
        case "indigo": return .indigo
        case "brown": return .brown
        case "teal": return .teal
        case "clear": return .clear
        default: return nil
        }
    }
}

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

extension Peg {
    static let missing = "clear"
}

struct Code {
    var kind: Kind
    var pegs: [Peg]

    init(kind: Kind = .unknown, length: Int = 4) {
        self.kind = kind
        pegs = [Peg](repeating: Peg.missing, count: length)
    }

    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }

    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }

    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Peg.missing
        }
    }

    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs

        /// 1st pass: compute exact matches via zip and ==
        let exactMatches: [Match] = zip(pegs, pegsToMatch).map {
            $0 == $1 ? .exact : .nomatch
        }

        /// 2nd pass: compute inexact matches while consuming from the remaining pegsToMatch pool
        return pegs.indices.map { index in
            if exactMatches[index] == .exact {
                return .exact
            }

            if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            }

            return .nomatch
        }
    }
}
