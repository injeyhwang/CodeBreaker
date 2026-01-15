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
    var body: some View {
        PegShape.shape
            .fill(peg)
            .contentShape(PegShape.shape)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxHeight: PegShape.maxHeight)
    }

    private enum PegShape {
        static let shape = Circle()
        static let maxHeight: CGFloat = 100
    }
}

#Preview {
    VStack {
        ForEach([Peg].masterMindPegs, id: \.self) { peg in
            PegView(peg: peg)
        }
    }
}
