//
//  HomePageView.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 15/03/2023.
//

import SwiftUI

struct HomePageView: View {
    var quotes: Array<String> = ["You are capable of achieving great things and overcoming any challenges that come your way.", "Today is a new day full of opportunities and possibilities for happiness and success.", "You are loved and appreciated by the people in your life, and you make a positive impact on those around you.", "Focus on the present moment and find joy in the little things in life.", "Believe in yourself and your abilities, and trust that you will make the right decisions.", "Take time for self-care and do things that bring you joy and peace.", "Remember that setbacks and failures are opportunities for growth and learning, and they do not define your worth or potential."]
    @State private var currentIndex = 0
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                HStack{
                    Image("HomeScreenGumballMachine")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 150)
                    Text("Welcome to MooDr.")
                    //                        .padding()
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.2))
                .cornerRadius(20)
                ZStack{
                    Image("HomeScreenHead")
                        .resizable()
                        .scaledToFit()
                        .overlay{
                            LinearGradient(colors: [.black,.clear, .clear],
                                           startPoint: .bottom,
                                           endPoint: .top)
                            .opacity(0.4)
                            .cornerRadius(20)
                            Text("\(currentIndex)/\(quotes.count-1)")
                                .font(.title)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding()
                                .foregroundColor(.white)
                            Text(quotes[currentIndex])
                                .font(.title2)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                                .padding()
                                .foregroundColor(.white)
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                                        currentIndex = (currentIndex + 1) % quotes.count
                                    }
                                }
                        }
                    
                }
            }
            .padding()
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

