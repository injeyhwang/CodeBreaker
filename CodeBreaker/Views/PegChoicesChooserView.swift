//
//  PegChoicesChooserView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/15/26.
//

import SwiftUI

struct PegChoicesChooserView: View {
    // MARK: Data shared with me
    @Binding var pegChoices: [Peg]

    // MARK: - Body
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(
                    selection: $pegChoices[index],
                    supportsOpacity: false
                ) {
                    actionButton(
                        title: "Peg Choice \(index + 1)",
                        systemImage: "minus.circle",
                        color: .red
                    ) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            actionButton(
                title: "Add Peg Choice",
                systemImage: "plus.circle",
                color: .green)
            {
                pegChoices.append(.missing)
            }
        }
    }

    private func actionButton(
        title: String,
        systemImage: String,
        color: Color? = nil,
        _ action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage)
                    .tint(color)
            }
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = [.green, .red]
    PegChoicesChooserView(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices: \(pegChoices)")
        }
}
