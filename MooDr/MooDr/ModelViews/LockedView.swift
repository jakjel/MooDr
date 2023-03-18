//
//  SwiftUIView.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 08/03/2023.
//

import SwiftUI

struct LockedView: View {
    var timeUntilAvailable: (hours: Int, minutes: Int)?
    
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.pink, .clear]), startPoint: .top, endPoint: .bottomTrailing)
                .mask(
            Image(systemName: "lock.circle")
                .resizable()
            ).frame(width: 200, height: 200)
            Text("Locked")
                .font(.largeTitle)
            if let timeUntilAvailable = timeUntilAvailable {
                Text("Remaining waiting time: \(timeUntilAvailable.hours) hours and \(timeUntilAvailable.minutes) minutes.")
                    .font(.footnote)
            }
        }.frame(width: 300)
    }
}

