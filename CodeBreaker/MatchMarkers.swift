//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    let matches: [Match]

    private let gridRow = [GridItem(.fixed(20)), GridItem(.fixed(20))]

    var body: some View {
        LazyHGrid(rows: gridRow) {
            ForEach(matches.indices, id: \.self) { index in
                matchMarker(peg: index)
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

struct PreviewMatchMarkers: View {
    let matches: [Match]

    var body: some View {
        HStack {
            ForEach(matches.indices, id: \.self) { _ in
                Circle()
                    .fill(Color.primary)
                    .frame(width: 40, height: 40)
            }

            MatchMarkers(matches: matches)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewMatchMarkers(matches: [.exact, .inexact, .inexact])
    PreviewMatchMarkers(matches: [.exact, .nomatch, .nomatch])
    PreviewMatchMarkers(matches: [.exact, .exact, .inexact, .inexact])
    PreviewMatchMarkers(matches: [.exact, .exact, .inexact, .nomatch])
    PreviewMatchMarkers(matches: [.exact, .inexact, .nomatch, .nomatch])
    PreviewMatchMarkers(matches: [.exact, .exact, .exact, .inexact, .nomatch, .nomatch])
    PreviewMatchMarkers(matches: [.exact, .exact, .exact, .inexact, .inexact, .inexact])
    PreviewMatchMarkers(matches: [.exact, .exact, .inexact, .inexact, .inexact])
    PreviewMatchMarkers(matches: [.exact, .inexact, .inexact, .nomatch, .nomatch])
}
