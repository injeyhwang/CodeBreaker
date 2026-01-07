//
//  View+Typography.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/7/26.
//

import SwiftUI

extension View {
    func flexibleSystemFont(min: CGFloat = 8, max: CGFloat = 80) -> some View {
        self.font(.system(size: max))
            .minimumScaleFactor(min / max)
    }
}
