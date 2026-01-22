//
//  PegView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/30/25.
//

import SwiftUI

struct PegView: View {
    let peg: Peg

    var body: some View {
        PegShape.shape
            .stroke(peg.isWhite ? .black : .clear)
            .fill(peg.toColor)
            .contentShape(PegShape.shape)
            .aspectRatio(1, contentMode: .fit)
    }
}

extension PegView {
    private enum PegShape {
        static let shape = Circle()
    }
}

#Preview {
    VStack {
        ForEach([Peg].allPegs, id: \.self) { peg in
            PegView(peg: peg)
        }
    }
}
