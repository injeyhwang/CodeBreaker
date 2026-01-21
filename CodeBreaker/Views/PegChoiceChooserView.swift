//
//  PegChoiceChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/21/26.
//

import SwiftUI

struct PegChoiceChooserView: View {
    @Binding var pegToEdit: Peg
    @Environment(\.dismiss) var dismiss
    let index: Int
    let columns = [GridItem(.adaptive(minimum: Selection.size))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach([Peg].allPegs, id: \.self) { peg in
                        PegView(peg: peg)
                            .frame(maxHeight: PegChoice.pegSize)
                            .onTapGesture {
                                withAnimation { pegToEdit = peg }
                            }
                            .padding(PegChoice.padding)
                            .overlay {
                                if pegToEdit == peg { selector(peg: peg) }
                            }
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", role: .confirm) { dismiss() }
                }
            }
            .navigationTitle("Peg Choice \(index + 1)")
        }
    }

    private func selector(peg: Peg) -> some View {
        Selection.shape
            .stroke(
                pegToEdit.isWhite ? .black : peg.toColor,
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
    }
}

#Preview {
    @Previewable @State var peg: Peg = "green"
    PegChoiceChooserView(pegToEdit: $peg, index: 0)
}

