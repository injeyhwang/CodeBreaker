//
//  Code+Kind.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/18/26.
//

extension Code {
    enum Match: String {
        case nomatch
        case exact
        case inexact
    }

    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
}
