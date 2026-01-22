//
//  MatchMarkersView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 12/24/25.
//

import SwiftUI

struct MatchMarkersView: View {
    let matches: [Code.Match]

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
            .frame(width: MatchMarker.size, height: MatchMarker.size)
    }
}

extension MatchMarkersView {
    private enum MatchMarker {
        static let size: CGFloat = 20
    }
}

#Preview {
    List {
        MatchMarkersView(matches: [.exact, .inexact, .inexact])
        MatchMarkersView(matches: [.exact, .nomatch, .nomatch])
        MatchMarkersView(matches: [.exact, .exact, .inexact, .inexact])
        MatchMarkersView(matches: [.exact, .exact, .inexact, .nomatch])
        MatchMarkersView(matches: [.exact, .inexact, .nomatch, .nomatch])
        MatchMarkersView(matches: [.exact, .exact, .exact, .inexact, .nomatch, .nomatch])
        MatchMarkersView(matches: [.exact, .exact, .exact, .inexact, .inexact, .inexact])
        MatchMarkersView(matches: [.exact, .exact, .inexact, .inexact, .inexact])
        MatchMarkersView(matches: [.exact, .inexact, .inexact, .nomatch, .nomatch])
    }
}
