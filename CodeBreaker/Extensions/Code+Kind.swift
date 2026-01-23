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

        init(_ rawValue: String) {
            let parsedValue = rawValue.split(
                separator: Encode.data,
                maxSplits: 1
            )
            let kind = String(parsedValue.first ?? "")
            let data = parsedValue.count > 1 ? String(parsedValue[1]) : ""

            switch kind {
            case "master":
                self = .master(isHidden: Bool(data) ?? false)
            case "guess":
                self = .guess
            case "attempt":
                let matches = data
                    .split(separator: Encode.array)
                    .compactMap { Match(rawValue: String($0)) }
                self = .attempt(matches)
            default:
                self = .unknown
            }
        }

        var toString: String {
            switch self {
            case .master(let isHidden):
                return "master\(Encode.data)\(isHidden)"
            case .guess:
                return "guess"
            case .attempt(let matches):
                let data = matches
                    .map(\.rawValue)
                    .joined(separator: Encode.array)
                return "attempt\(Encode.data)\(data)"
            case .unknown:
                return "unknown"
            }
        }
    }
}

private extension Code.Kind {
    enum Encode {
        static let data: String = ":"
        static let array: String = ","
    }
}
