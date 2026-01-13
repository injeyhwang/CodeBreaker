//
//  CodeBreaker+Protocols.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/13/26.
//

import SwiftUI

extension CodeBreaker: Equatable, Identifiable, Hashable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
