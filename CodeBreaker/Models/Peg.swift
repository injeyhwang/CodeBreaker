//
//  Peg.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

typealias Peg = String

extension Peg {
    static let missing = "missing"

    var isMissing: Bool { self == .missing }

    var isWhite: Bool { self == "white" }

    var toColor: Color {
        switch self {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "yellow": return .yellow
        case "orange": return .orange
        case "brown": return .brown
        case "black": return .black
        case "gray": return .gray
        case "indigo": return .indigo
        case "cyan": return .cyan
        case "purple": return .purple
        case "pink": return .pink
        case "mint": return .mint
        case "teal": return .teal
        case "white": return .white
        case "missing": return .clear
        default: return .clear
        }
    }
}

// Preset pegs for respective game types
extension [Peg] {
    static let masterMindPegs: [Peg] = [
        "red", "green", "blue", "yellow"
    ]

    static let earthTonesPegs: [Peg] = [
        "orange", "brown", "black", "gray"
    ]

    static let underSeaPegs: [Peg] = ["blue", "indigo", "cyan"]

    static let allPegs: [Peg] = [
        "red", "green", "blue", "yellow", "orange", "brown", "black", "gray",
        "indigo", "cyan", "purple", "pink", "mint", "teal", "white"
    ]
}
