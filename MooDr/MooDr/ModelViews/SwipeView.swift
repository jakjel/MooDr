//
//  SwipeView.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 01/03/2023.
//

import SwiftUI
import EventKit

struct SwipeView: View {
    @ObservedObject var eventManager: EventManager
    @State var swipes: Int = 0 //this could be stored in a local memory so the user starts where he finished
    @Binding var moods: Array<Int>
    @State var swipesWithoutReturn = 0
    let todayStart = Calendar.current.startOfDay(for: Date())
    @State var info: Bool = false
    @State var secondChanceSwipes: Array<EKEvent> = []
    @State var swipedOut: Bool = UserDefaults.standard.object(forKey: "done") as? Bool ?? false
    @State var lastSwipedOutDate : Date = UserDefaults.standard.object(forKey: "lastOpenedDate") as? Date ?? Date()
    let moodsHelper: [MoodHelper] =
        [MoodHelper(mood: "Sad", gradientIndex: 0),
         MoodHelper(mood: "Happy", gradientIndex: 1),
         MoodHelper(mood: "Excited", gradientIndex: 2),
         MoodHelper(mood: "Frustrated", gradientIndex: 3),
         MoodHelper(mood: "Angry", gradientIndex: 4),
         MoodHelper(mood: "Bored", gradientIndex: 5)
        ]
    let gradients: Array<LinearGradient> = [LinearGradient(colors: [.red, .red],
                                                           startPoint: .leading,
                                                           endPoint: .trailing),//sad
                                            LinearGradient(colors: [.green, .green],
                                                           startPoint: .trailing,
                                                           endPoint: .leading),//happy
                                            LinearGradient(colors: [.blue, .green],
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing),//excited
                                            LinearGradient(colors: [.red, .orange],
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing),//frustrated
                                            LinearGradient(colors: [.blue, .red],
                                                           startPoint: .topTrailing,
                                                           endPoint: .bottomLeading),//angry
                                            LinearGradient(colors: [.green, .orange],
                                                           startPoint: .topTrailing,
                                                           endPoint: .bottomLeading)//bored
    ]
    
    var body: some View {
        ZStack{
            Button("Return", action: mulligan)
                .disabled(swipes > 0 ? false : true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding()
            if !swipedOut {
                if swipes < $eventManager.events.count{
                    ForEach(eventManager.events, id: \.self){
                        event in
                        TindMoodView(event: event, moods: $moods, swipes: $swipes)
                    }
                }else if swipes == $eventManager.events.count {
                    Text("You had no more events today")
                        .onAppear(perform: swipedOutCheck)
                }
            }else{
                Text("You had no more events today")
            }
            if info{
                ZStack{
                    Image("MoodsOverlay")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFit()
                        .padding()
                        .opacity(0.8)
                }
            }
            Image(systemName: "info.circle")
                .resizable()
                .frame(maxWidth: 20, maxHeight: 20)
                .position(x: 25)
                .onTapGesture(perform: infoStatusChange)
                .foregroundColor(info ? .gray.opacity(0.3) : .pink)
                .padding()
        }
        .onAppear(perform: checkForLastOpenedDay)
    }
    func infoStatusChange(){
        info = !info
    }
    func checkForLastOpenedDay(){
        if lastSwipedOutDate < todayStart {
            UserDefaults.standard.removeObject(forKey: "done")
            UserDefaults.standard.removeObject(forKey: "moods")
            UserDefaults.standard.removeObject(forKey: "notification")
            UserDefaults.standard.removeObject(forKey: "lastOpenedDate")
        }
    }
    func swipedOutCheck(){
        if swipes >= eventManager.events.count{
            UserDefaults.standard.set(true, forKey: "done")
            UserDefaults.standard.set(Date(), forKey: "lastOpenedDate")
            UserDefaults.standard.set(moods, forKey: "moods")
        }
    }
        func mulligan(){
            moods.removeLast()
            print(moods)
            secondChanceSwipes.append(eventManager.events.reversed()[swipesWithoutReturn-1])
            swipes-=1
            print(secondChanceSwipes)
        }
}

class MoodHelper: Hashable, Equatable, Codable {
    var mood: String
    var gradientIndex: Int
    
    init(mood: String, gradientIndex: Int) {
        self.mood = mood
        self.gradientIndex = gradientIndex
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mood)
        hasher.combine(gradientIndex)
    }
    
    static func == (lhs: MoodHelper, rhs: MoodHelper) -> Bool {
        return lhs.mood == rhs.mood && lhs.gradientIndex == rhs.gradientIndex
    }
}
