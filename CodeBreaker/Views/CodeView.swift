//
//  CodeView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/31/25.
//

import SwiftUI

struct CodeView<AuxView>: View where AuxView: View {
    // MARK: Data in
    let code: Code

    // MARK: Data shared by me
    @Binding var selection: Int

    // MARK: Data in
    @ViewBuilder let auxView: () -> AuxView

    // MARK: Data owned by me
    @Namespace private var selectionNamespace

    init(code: Code,
         selection: Binding<Int> = .constant(-1),
         @ViewBuilder auxView: @escaping () -> AuxView = { EmptyView() }) {
        self.code = code
        self._selection = selection
        self.auxView = auxView
    }

    // MARK: - Body
    var body: some View {
        HStack {
            // Horizontal Pegs
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.padding)
                    .background { // Selection background
                        Group {
                            if code.kind == .guess && selection == index {
                                Selection.shape
                                    .foregroundStyle(Selection.color)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                        .animation(.selection, value: selection)
                    }
                    .overlay { // Hidden code obscuring
                        Selection.shape
                            .foregroundStyle(code.isHidden ? .gray : .clear)
                            .transaction { transaction in
                                if code.isHidden { transaction.animation = nil }
                            }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }

            // Auxiliary View
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    auxView()
                }
        }
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 5
    static let color: Color = .blue.opacity(0.3)
    static let cornerRadius: CGFloat = 10
    static let padding: CGFloat = 5
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

#Preview {
    CodeView(code: CodeBreaker.mastermindGame.masterCode)
}
