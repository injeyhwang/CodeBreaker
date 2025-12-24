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

    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
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
            .aspectRatio(1, contentMode: .fit)
    }
}




#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch])
}
