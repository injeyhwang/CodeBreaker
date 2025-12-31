//
//  Code.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/30/25.
//

struct Code: Equatable {
    var kind: Kind
    var pegs: [Peg]

    init(kind: Kind = .unknown, length: Int = 4) {
        self.kind = kind
        pegs = [Peg](repeating: Peg.missing, count: length)
    }

    enum Match: Equatable {
        case nomatch
        case exact
        case inexact
    }

    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }

    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }

    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }

    mutating func randomize(from pegChoices: [Peg]) {
        pegs = pegs.indices.map { _ in
            pegChoices.randomElement() ?? Peg.missing
        }
    }

    mutating func reset() {
        pegs = [Peg](repeating: Peg.missing, count: pegs.count)
    }

    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs

        // 1st pass: compute exact matches via zip and ==
        let exactMatches: [Match] = zip(pegs, pegsToMatch).map {
            $0 == $1 ? .exact : .nomatch
        }

        // 2nd pass: compute inexact matches while consuming from the remaining pegsToMatch pool
        return pegs.indices.map { index in
            if exactMatches[index] == .exact {
                return .exact
            }

            if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch[matchIndex] = "" // mark as consumed
                return .inexact
            }

            return .nomatch
        }
    }
}
