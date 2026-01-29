//
//  PegChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

struct PegChooserView: View {
    let choices: [Peg]
    let onChoose: ((Peg) -> Void)?

    init(choices: [Peg], onChoose: ((Peg) -> Void)? = nil) {
        self.choices = choices
        self.onChoose = onChoose
    }

    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                if let onChoose {
                    Button {
                        onChoose(peg)
                    } label: {
                        PegView(peg: peg)
                            .frame(maxHeight: PegButton.maxHeight)
                    }
                } else {
                    PegView(peg: peg)
                        .frame(maxHeight: PegButton.maxHeight)
                }
            }
        }
    }
}

extension PegChooserView {
    private enum PegButton {
        static let maxHeight: CGFloat = 100
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
