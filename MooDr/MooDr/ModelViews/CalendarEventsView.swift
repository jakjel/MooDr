//
//  ContentView.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 28/02/2023.
//

import SwiftUI
import EventKit

struct CalendarEventsView: View {
    @ObservedObject var eventManager: EventManager
    var body: some View {
        VStack{
            Text("Events")
                .font(.title2)
                .bold()
                .padding()
            List{
                Section{
                    ForEach(eventManager.events, id: \.self){
                        event in
                        Text(event.title)
                    }
                }
            footer: {
                Text("You can swipe these everyday from 9pm to 9:30pm")
            }
            }
            
        }
    }
}


//struct CalendarEventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarEventsView(eventManager: EventManager(events: []))
//    }
//}


