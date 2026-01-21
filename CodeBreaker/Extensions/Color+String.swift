//
//  Color+String.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/19/26.
//

import SwiftUI

extension Color {
    var toString: String {
        switch self {
        case .red: return "red"
        case .green: return "green"
        case .blue: return "blue"
        case .yellow: return "yellow"
        case .orange: return "orange"
        case .brown: return "brown"
        case .black: return "black"
        case .gray: return "gray"
        case .indigo: return "indigo"
        case .cyan: return "cyan"
        case .purple: return "purple"
        case .pink: return "pink"
        case .mint: return "mint"
        case .teal: return "teal"
        case .white: return "white"
        case .clear: return "missing"
        default: return "missing"
        }
    }
}
