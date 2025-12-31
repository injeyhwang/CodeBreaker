//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

struct PegChooser: View {
    // MARK: Data in
    let choices: [Peg]

    // MARK: Data out function
    let onChoose: (Peg) -> Void

    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose(peg)
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

#Preview {
    VStack {
        PegChooser(choices: CodeBreaker.colorChoices) { _ in }
        PegChooser(choices: CodeBreaker.faceEmojiChoices) { _ in }
        PegChooser(choices: CodeBreaker.flagEmojiChoices) { _ in }
    }
    .padding()
}
