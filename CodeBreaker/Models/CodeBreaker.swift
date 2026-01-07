//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/27/25.
//

struct CodeBreaker {
    static let colorChoices = ["red", "green", "blue", "yellow"]
    static let flagEmojiChoices = ["🇰🇷", "🇨🇦", "🇺🇸", "🇬🇧"]
    static let faceEmojiChoices = ["😊", "🤣", "😂", "😭", "🥰"]

    static let allPegChoices = [
        Self.colorChoices,
        Self.faceEmojiChoices,
        Self.flagEmojiChoices
    ]

    var masterCode: Code
    var guess: Code
    var attempts: [Code]
    var pegChoices: [Peg]

    init(pegChoices: [Peg], pegLength: Int) {
        masterCode = Code(kind: .master(isHidden: true), length: pegLength)
        guess = Code(kind: .guess, length: pegLength)
        attempts = [Code]()
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
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
        }
    }

    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        
        guess.pegs[index] = peg
    }
}
