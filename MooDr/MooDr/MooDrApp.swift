//
//  MooDrApp.swift
//  MooDr
//
//  Created by Jakub Jelinek on 15/03/2023.
//

import SwiftUI

@main
struct MooDrApp: App {
    @State var eventManager:
    EventManager = EventManager(events: [])
    var body: some Scene {
        WindowGroup {
            ContentView(eventManager: eventManager)
                .onAppear(perform:eventManager.fetchEvents)
        }
    }
}
