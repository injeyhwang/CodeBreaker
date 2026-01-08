//
//  TimerView.swift
//  CodeBreaker
//
//  Created by In Jey Hwang on 1/8/26.
//

import SwiftUI

struct TimerView: View {
    // MARK: Data in
    let startTime: Date
    let endTime: Date?

    var body: some View {
        if let endTime {
            Text(endTime, format: timerFormatStyle)
        } else {
            Text(TimeDataSource<Date>.currentDate, format: timerFormatStyle)
        }
    }

    private var timerFormatStyle: SystemFormatStyle.DateOffset {
        .offset(to: startTime, allowedFields: [.minute, .second])
    }
}


#Preview {
    TimerView(startTime: .now, endTime: nil)
}
