//
//  SwiftDataPreview.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/26/26.
//

import SwiftData
import SwiftUI

struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: CodeBreaker.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        // may load up some sample data into container.mainContext
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor
    static var swiftData: Self = .modifier(SwiftDataPreview())
}
