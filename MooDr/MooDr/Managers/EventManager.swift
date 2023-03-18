//
//  File.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 07/03/2023.
//

import SwiftUI
import EventKit

class EventManager : NSObject, ObservableObject{
    @Published var events: [EKEvent]
    @Published var eventStore = EKEventStore()
    
    init(events: [EKEvent]) {
        self.events = events
    }
    
    func fetchEvents() {
        eventStore.requestAccess(to: .event) { [self] granted, error in
            if let error = error {
                print("Error requesting access to calendar: \(error)")
            } else if granted {
                loadEvents()
            }
        }
    }
    func loadEvents(){
        let now = Date.now
        let startOfDay = Calendar.current.startOfDay(for: now)
        var endOfDay: Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfDay)!
        }
        let predicate = eventStore.predicateForEvents(withStart: startOfDay,end: endOfDay, calendars: nil)
        let events = eventStore.events(matching: predicate)
        DispatchQueue.main.async {
            self.events = events
        }
    }
    

}
