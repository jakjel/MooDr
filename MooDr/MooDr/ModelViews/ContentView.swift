//
//  SwiftUIView.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 07/03/2023.
//

import SwiftUI
import Foundation
import UserNotifications


struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject var eventManager: EventManager
    @State private var swipeViewEnabled = false
    @State var moods: Array<Int> = UserDefaults.standard.object(forKey: "moods") as? Array<Int> ?? []
    @StateObject var healthStore: HealthStore = HealthStore()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            if swipeViewEnabled {
                SwipeView(eventManager: eventManager, moods: $moods)
                    .tabItem {
                        Image(systemName: "hand.draw")
                        Text("Swipe your day")
                    }.tag(1)
            }else{
                LockedView(timeUntilAvailable: timeUntilSwipeViewAvailable())
                    .tabItem {
                        Image(systemName: "hand.draw")
                        Text("Swipe your day")
                    }.tag(1)
            }
            CalendarEventsView(eventManager: eventManager)
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("Events")
                }.tag(2)
            BarChart(moods: $moods, healthStore: healthStore)
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Charts")
                }.tag(3)
        }
        .onChange(of: selectedTab){ _ in
            eventManager.fetchEvents()
        }
        .onAppear {
            swipeChecking()
            scheduleNotification()
        }.accentColor(Color.pink)
    }
    func swipeChecking(){
        let currentTime = Date()
        
        //this is the RIGHT code !!!
        let swipeViewStartTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: currentTime)!
        let swipeViewEndTime = Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: currentTime)!
        if currentTime >= swipeViewStartTime && currentTime < swipeViewEndTime {
            swipeViewEnabled = true
        } else {
            swipeViewEnabled = false
        }
        
    }
    func timeUntilSwipeViewAvailable() -> (hours: Int, minutes: Int)? {
        let currentTime = Date()
        let swipeViewStartTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: currentTime)!
        let swipeViewEndTime = Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: currentTime)!
        let currentTimeTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentTime)!
        let swipeStartTimeTomorrow = Calendar.current.date(bySettingHour: 21, minute: 00, second: 0, of: currentTimeTomorrow)!
        
        
        if currentTime < swipeViewStartTime {
            let timeInterval = swipeViewStartTime.timeIntervalSince(currentTime)
            let hours = Int(timeInterval / 3600)
            let minutes = Int((timeInterval / 60).truncatingRemainder(dividingBy: 60))
            return (hours, minutes)
        }else if currentTime > swipeViewEndTime {
            let timeInterval = swipeStartTimeTomorrow.timeIntervalSince(currentTime)
            let hours = Int(timeInterval / 3600)
            let minutes = Int((timeInterval / 60).truncatingRemainder(dividingBy: 60))
            return (hours, minutes)
        }
        return nil
    }
    //ask how to put these functions in an extra file so it is not such a mess, maybe extension??? dont know
    func scheduleNotification() {
        let notificationSet : Bool = UserDefaults.standard.object(forKey: "notification") as? Bool ?? false
        if !notificationSet{
            let content = UNMutableNotificationContent()
            content.title = "MooDr."
            content.body = "Swipe your day is now available."
            content.sound = UNNotificationSound.default
            
            // Create a date 5 minutes before 9pm
            var dateComponents = DateComponents()
            dateComponents.hour = 21 // 9pm in 24-hour format
            dateComponents.minute = 00 // 5 minutes before 9pm
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Request authorization to schedule notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                guard granted && error == nil else {
                    print("Failed to request authorization for notifications")
                    return
                }
                
                // Schedule the notification
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Failed to schedule notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled successfully")
                        UserDefaults.standard.set(true, forKey: "notification")
                    }
                }
            }
            
        }else{
            print("Notification already set")
            print(UserDefaults.standard.object(forKey: "notification") as? Bool ?? false)
        }
    }
    
}





