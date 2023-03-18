//
//  Mood.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 14/03/2023.
//

import SwiftUI

class Mood{
    @Published var mood: String
    @Published var moodId: Int
    
    init(mood: String, moodId: Int) {
        self.mood = mood
        self.moodId = moodId
    }
}
