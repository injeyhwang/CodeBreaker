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
        var pegsToMatch = otherCode.pegs.map(Optional.some)

        // 1st pass: compute exact matches
        let exactMatches: [Match] = pegs.indices.map { index in
            if pegs[index] == pegsToMatch[index] {
                pegsToMatch[index] = nil // mark as consumed
                return .exact
            }

            return .nomatch
        }

        // 2nd pass: compute inexact matches
        return pegs.indices.map { index in
            if exactMatches[index] == .exact {
                return .exact
            }

            if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch[matchIndex] = nil // mark as consumed
                return .inexact
            }

            return .nomatch
        }
    }
}
