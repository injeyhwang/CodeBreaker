//
//  MatchMarkersView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct MatchMarkersView: View {
    // MARK: Data in
    let matches: [Code.Match]

    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                if matches.count > 3 {
                    matchMarker(peg: 3)
                }
            }
            VStack {
                if matches.count > 4 {
                    matchMarker(peg: 4)
                }
                if matches.count > 5 {
                    matchMarker(peg: 5)
                }
            }
        }
    }

    @ViewBuilder
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .nomatch }

        Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear)
            .frame(width: 20, height: 20)
    }
}

private struct PreviewMatchMarkersView: View {
    let matches: [Code.Match]

    var body: some View {
        HStack {
            ForEach(matches.indices, id: \.self) { _ in
                Circle()
                    .fill(Color.primary)
                    .frame(width: 40, height: 40)
            }

            MatchMarkersView(matches: matches)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewMatchMarkersView(matches: [.exact, .inexact, .inexact])
    PreviewMatchMarkersView(matches: [.exact, .nomatch, .nomatch])
    PreviewMatchMarkersView(matches: [.exact, .exact, .inexact, .inexact])
    PreviewMatchMarkersView(matches: [.exact, .exact, .inexact, .nomatch])
    PreviewMatchMarkersView(matches: [.exact, .inexact, .nomatch, .nomatch])
    PreviewMatchMarkersView(matches: [.exact, .exact, .exact, .inexact, .nomatch, .nomatch])
    PreviewMatchMarkersView(matches: [.exact, .exact, .exact, .inexact, .inexact, .inexact])
    PreviewMatchMarkersView(matches: [.exact, .exact, .inexact, .inexact, .inexact])
    PreviewMatchMarkersView(matches: [.exact, .inexact, .inexact, .nomatch, .nomatch])
}
