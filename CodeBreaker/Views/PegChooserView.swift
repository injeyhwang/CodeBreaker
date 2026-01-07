//
//  PegChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

struct PegChooserView: View {
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
        PegChooserView(choices: CodeBreaker.colorChoices) { _ in }
        PegChooserView(choices: CodeBreaker.faceEmojiChoices) { _ in }
        PegChooserView(choices: CodeBreaker.flagEmojiChoices) { _ in }
    }
    .padding()
}
