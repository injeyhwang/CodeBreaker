//
//  CodeView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data in
    let code: Code

    // MARK: Data shared by me
    @Binding var selection: Int

    // MARK: - Body
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index])
                .padding(Selection.padding)
                .background {
                    if code.kind == .guess && selection == index {
                        Selection.shape
                            .foregroundStyle(Selection.color)
                    }
                }
                .overlay {
                    if code.isHidden {
                        Selection.shape.foregroundStyle(.gray)
                    }
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }

    private struct Selection {
        static let border: CGFloat = 5
        static let color: Color = .blue.opacity(0.3)
        static let cornerRadius: CGFloat = 10
        static let padding: CGFloat = 5
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}

#Preview {
    HStack {
        CodeView(code: Code(kind: .guess, length: 4), selection: .constant(0))
    }
    .padding()
}
