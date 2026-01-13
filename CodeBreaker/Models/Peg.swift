//
//  Peg.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

typealias Peg = String

extension Peg {
    static let missing = "clear"

    var isMissing: Bool { self == .missing }

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

// Preset pegs for respective game types
extension [Peg] {
    static let masterMindPegs = ["red", "green", "blue", "yellow"]
    static let earthTonesPegs = ["orange", "brown", "black", "gray"]
    static let underSeaPegs = ["blue", "indigo", "cyan"]
}
