//
//  PegChoiceChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/21/26.
//

import SwiftUI

struct PegChoiceChooserView: View {
    @Binding var pegChoices: [Peg]
    @Environment(\.dismiss) var dismiss
    let pegChoiceIndex: Int
    let columns = [GridItem(.adaptive(minimum: Selection.size))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach([Peg].allPegs, id: \.self) { peg in
                        pegButton(peg: peg)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", role: .confirm) { dismiss() }
                }
            }
            .navigationTitle("Peg Choice \(pegChoiceIndex + 1)")
        }
    }

    private func isNotAvailable(peg: Peg) -> Bool {
        chosenPegs.contains(peg)
    }

    private var chosenPegs: Set<Peg> {
        Set(pegChoices.enumerated().compactMap { index, peg in
            index == pegChoiceIndex ? nil : peg
        })
    }

    private func pegButton(peg: Peg) -> some View {
        let isUnavailable = isNotAvailable(peg: peg)
        return Button {
            withAnimation {
                pegChoices[pegChoiceIndex] = peg
            }
        } label: {
            ZStack {
                PegView(peg: peg)
                    .frame(maxHeight: PegChoice.pegSize)
                    .padding(PegChoice.padding)

                if pegChoices[pegChoiceIndex] == peg {
                    selectionRing(peg: peg)
                }
            }
        }
        .disabled(isUnavailable)
        .opacity(isUnavailable ? Selection.unavailable : 1)
    }

    private func selectionRing(peg: Peg) -> some View {
        Selection.shape
            .stroke(
                pegChoices[pegChoiceIndex].isWhite ? .black : peg.toColor,
                lineWidth: Selection.lineWidth
            )
            .frame(maxHeight: Selection.size)
    }
}

extension PegChoiceChooserView {
    private enum PegChoice {
        static let shape = Circle()
        static let padding: CGFloat = 10
        static let pegSize: CGFloat = 50
    }

    private enum Selection {
        static let shape = Circle()
        static let lineWidth: CGFloat = 5
        static let size: CGFloat = 60
        static let unavailable: Double = 0.5
    }
}

#Preview {
    @Previewable @State var choices: [Peg] = ["green"]
    PegChoiceChooserView(pegChoices: $choices, pegChoiceIndex: 0)
}
