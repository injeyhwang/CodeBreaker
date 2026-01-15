//
//  Peg.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

typealias Peg = Color

extension Peg {
    static let missing = Peg.clear

    var isMissing: Bool { self == .missing }
}

// Preset pegs for respective game types
extension [Peg] {
    static let masterMindPegs: [Peg] = [.red, .green, .blue, .yellow]
    static let earthTonesPegs: [Peg] = [.orange, .brown, .black, .gray]
    static let underSeaPegs: [Peg] = [.blue, .indigo, .cyan]
}
