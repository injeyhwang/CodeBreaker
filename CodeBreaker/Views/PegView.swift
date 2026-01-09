//
//  PegView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/30/25.
//

import SwiftUI

struct PegView: View {
    // MARK: Data in
    let peg: Peg

    // MARK: - Body
    let pegShape = Circle()

    // MARK:  - Body
    var body: some View {
        ZStack {
            if let colorized = peg.colorize {
                pegShape
                    .fill(colorized)
                    .strokeBorder(colorized)

            } else {
                pegShape
                    .fill(.clear)
                Text(peg)
                    .font(.largeTitle)
            }
        }
        .contentShape(pegShape)
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct PreviewPegView: View {
    let pegs: [Peg]

    var body: some View {
        HStack {
            ForEach(pegs, id: \.self) { peg in
                PegView(peg: peg)
            }
        }
    }
}

#Preview {
    VStack {
        PreviewPegView(pegs: [Peg.missing, "red", "yellow", "green", "blue"])
        PreviewPegView(pegs: [Peg.missing, "✌🏼", "👋🏼", "🙏🏼", "🫰🏼"])
    }
    .padding()
}
