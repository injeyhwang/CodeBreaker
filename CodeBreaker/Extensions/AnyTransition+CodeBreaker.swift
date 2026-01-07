//
//  AnyTransition+CodeBreaker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/7/26.
//

import SwiftUI

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y: 200)

    static func attempt(_ isOver: Bool) -> AnyTransition {
        .asymmetric(insertion: isOver ? .opacity : .move(edge: .top),
                    removal: .move(edge: .trailing))
    }
}
