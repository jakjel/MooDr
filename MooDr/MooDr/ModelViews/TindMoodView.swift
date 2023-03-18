//
//  TindMoodView.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 01/03/2023.
//

import SwiftUI
import EventKit

struct TindMoodView: View {
    var event : EKEvent
    @State private var offset = CGSize.zero
    @Binding var moods : Array<Int>
    @State private var gradient : LinearGradient = LinearGradient(colors: [.black, .black],
                                                                  startPoint: .top,
                                                                  endPoint: .bottom)
    @Binding var swipes: Int
    var body: some View {
        ZStack{
            Rectangle()
                .fill(gradient.opacity(0.8))
                .cornerRadius(20)
                .frame(width: 320, height: 420)
                .shadow(radius: 4)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 20)
                               .stroke(Color.white, lineWidth: 2)
                    Text(event.title)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(20)
                        .multilineTextAlignment(.center)
                        .bold()
                })
        }
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(.degrees(Double(offset.width / 30)))
        .gesture(DragGesture()
            .onChanged{ gesture in
                offset = gesture.translation
//                print("width: \(offset.width)")
//                print("height: \(offset.height)")
                withAnimation{
                    colorChange(height: offset.height, width: offset.width)
                }
            }
            .onEnded{ _ in
                withAnimation{
                    switching(height: offset.height, width: offset.width)
                    colorChange(height: offset.height, width: offset.width)
                    print(swipes)
                    print(moods)
                }
                
            }
        )
    }
    func switching(height: CGFloat, width: CGFloat){
        if -500...(-150) ~= width && -100...100 ~= height{//swipe left
            offset = CGSize(width: -500, height: 0)
            swipes += 1
            moods.append(1)
        } else if 150...500 ~= width && -100...100 ~= height{//swipe right
            offset = CGSize(width: 500, height: 0)
            swipes += 1
            moods.append(4)
        }else if -700...(-200) ~= height && -500...(-55) ~= width{//swipe top left
            offset = CGSize(width: -460, height: -700)
            swipes += 1
            moods.append(2)
        }
        else if -700...(-200) ~= height && 55...500 ~= width{//swipe top right
            offset = CGSize(width: 460, height: -700)
            swipes += 1
            moods.append(3)
        }else if 200...700 ~= height && -500...(-55) ~= width{//swipe bottom left
            offset = CGSize(width: -460, height: 700)
            swipes += 1
            moods.append(6)
        }
        else if 200...700 ~= height && 55...500 ~= width{//swipe bottom right
            offset = CGSize(width: 460, height: 700)
            swipes += 1
            moods.append(5)
        }else{
            offset = .zero
        }
    }
    func colorChange(height: CGFloat, width: CGFloat){
        if -500...(-120) ~= width && -90...90 ~= height{//left
            gradient = LinearGradient(colors: [.red, .red],
                                      startPoint: .leading,
                                      endPoint: .trailing)
        } else if 120...500 ~= width && -90...90 ~= height{//right
            gradient = LinearGradient(colors: [.green, .green],
                                      startPoint: .trailing,
                                      endPoint: .leading)
        }else if 180...700 ~= height && 50...500 ~= width{//bottom right
            gradient = LinearGradient(colors: [.green, .orange],
                                      startPoint: .topTrailing,
                                      endPoint: .bottomLeading)
        }
        else if 180...700 ~= height && -500...(-50) ~= width{//bottom left
            gradient = LinearGradient(colors: [.red, .orange],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)
        }
        else if 50...500 ~= width && -700...(-180) ~= height{//top right
            gradient = LinearGradient(colors: [.blue, .green],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)
        }
        else if -500...(-50) ~= width && -700...(-180) ~= height{//top left
            gradient = LinearGradient(colors: [.blue, .red],
                                      startPoint: .topTrailing,
                                      endPoint: .bottomLeading)
        }
        else{
            gradient = LinearGradient(colors: [.black, .black],
                                      startPoint: .top,
                                      endPoint: .bottom)
        }
    }
}



