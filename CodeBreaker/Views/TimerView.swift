//
//  TimerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/8/26.
//

import SwiftUI

struct TimerView: View {
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval

    var body: some View {
        if startTime != nil {
            if let endTime {
                Text(endTime, format: timerFormat)
            } else {
                Text(TimeDataSource<Date>.currentDate, format: timerFormat)
            }
        } else {
            Image(systemName: "pause")
        }
    }

    private var timeDiff: Date { startTime! - elapsedTime }

    private var timerFormat: SystemFormatStyle.DateOffset {
        .offset(to: timeDiff, allowedFields: [.minute, .second])
    }
}

#Preview {
    TimerView(startTime: .now, endTime: nil, elapsedTime: 0)
    TimerView(startTime: nil, endTime: nil, elapsedTime: 0)
}
