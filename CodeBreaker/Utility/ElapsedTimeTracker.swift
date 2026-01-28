//
//  ElapsedTimeTracker.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/28/26.
//

import SwiftData
import SwiftUI

extension View {
    func trackElapsedTime(for game: CodeBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

private struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    let game: CodeBreaker

    var modelContextWillSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(
            for: ModelContext.willSave,
            object: modelContext
        )
    }

    func body(content: Content) -> some View {
        content
            .onAppear { game.startTimer() }
            .onDisappear { game.pauseTimer() }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
            // this code will execute everything the database is about to save
            .onReceive(modelContextWillSavePublisher) { _ in
                game.updateElapsedTime()
                print("updated elapsed time to \(game.elapsedTime)")
            }
    }
}
