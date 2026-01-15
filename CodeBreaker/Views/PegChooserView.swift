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
    let onChoose: ((Peg) -> Void)?

    init(choices: [Peg], onChoose: ((Peg) -> Void)? = nil) {
        self.choices = choices
        self.onChoose = onChoose
    }

    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

#Preview {
    VStack {
        PegChooserView(choices: .masterMindPegs)
        PegChooserView(choices: .earthTonesPegs)
        PegChooserView(choices: .underSeaPegs)
    }
    .padding()
}
