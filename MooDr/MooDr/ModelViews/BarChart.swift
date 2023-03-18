//
//  BarChartView.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 13/03/2023.
//

import SwiftUI
import Charts

struct BarChart: View {
    @Binding var moods : Array<Int>
    @State private var moodsString: Array<String> = []
    @State private var listData: ListData = ListData(mood: "", count: 0.0)
    @State private var countResults: [String: Double] = [:]
    @State var finalResults: Array<ListData> = []
    @State var healthStore: HealthStore
    @State var hrvSamples: [Double] = []

    var body: some View {
        VStack{
            Text("Charts")
                .font(.title2)
                .bold()
                .padding()
            if moods.count > 0 {
                List{
                    Section{
                        Chart {
                            ForEach(finalResults) { result in
                                BarMark(
                                    x: .value("Total Count", result.count),
                                    y: .value("Mood", result.mood)
                                )
                                .cornerRadius(5)
                                .foregroundStyle(LinearGradient(colors: [.orange, .pink, .purple, .blue],
                                                                startPoint: .leading,
                                                                endPoint: .trailing))
                            }
                        }
                        .frame(height: 350)
                        .padding(.vertical)
                    }header: {
                        Text("Moods experienced during events today horizontal")
                    }
                    Section{
                        Chart {
                            ForEach(finalResults) { result in
                                BarMark(
                                    
                                    x: .value("Mood", result.mood),
                                    y: .value("Total Count", result.count)
                                )
                                .cornerRadius(5)
                                .foregroundStyle(LinearGradient(colors: [.orange, .pink, .purple, .blue],
                                                                startPoint: .bottom,
                                                                endPoint: .top))
                            }
                        }
                        .padding(.vertical)
                        .frame(height: 300)
                        .onAppear(perform: getResults)
                    }header: {
                        Text("Moods experienced during events today vertical (total)")
                    }
                    Section{
                        if !hrvSamples.isEmpty {
                            LineChart(dataPoints: hrvSamples)
                                .frame(height: 300)
                                .padding()
                        } else {
                            Text("No HRV data available")
                        }
                    }
                    .onAppear {
                        fetchHRVData()
                    }
                    Button("Remove mood values", action: removeMoodValues)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }else{
                Text("There are no values yet!")
            }
        }
    }
    func getResults(){
        finalResults.removeAll()
        countResults.removeAll()
        moodsString.removeAll()
        print(moods)
        moodIndicator()
        counting(moods: moods)
        for (_, item)in moodsString.enumerated(){
            listData.mood = item
            listData.count = countResults[item]!
//            results.append((mood: item, value: countResults[item]!)) //for the fancy chart
            finalResults.append(listData)
        }
    }
    
    func moodIndicator(){
        moods.forEach{
            mood in
            switch mood{
            case 1:
                moodsString.append("Sad")
            case 2:
                moodsString.append("Angry")
            case 3:
                moodsString.append("Excited")
            case 4:
                moodsString.append("Happy")
            case 5:
                moodsString.append("Bored")
            case 6:
                moodsString.append("Frustrated")
            default:
                print("aaaaa kurva")
            }
        }
        let unique = moodsString.removingDuplicates()
        moodsString = unique
    }
    func counting(moods: [Int]){
        moods.forEach{
            original in
            switch original{
            case 1:
                countResults["Sad", default: 0] += 1
            case 2:
                countResults["Angry",default: 0] += 1
            case 3:
                countResults["Excited",default: 0] += 1
            case 4:
                countResults["Happy",default: 0] += 1
            case 5:
                countResults["Bored",default: 0] += 1
            case 6:
                countResults["Frustrated",default: 0] += 1
            default:
                break
            }
        }
    }
    func removeMoodValues(){
        UserDefaults.standard.removeObject(forKey: "moods")
        moods.removeAll()
    }
    func fetchHRVData() {
        healthStore.requestAuthorization { success in
            if success {
                healthStore.getHRVData { samples in
                    hrvSamples = samples.reversed()
                    print(samples)
                }
            }
        }
    }
}




//extension that deletes duplicates
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

struct ListData : Hashable, Identifiable{
    var id = UUID()
    var mood: String
    var count: Double
}

//BarChartView(data: ChartData(values: results), title: "MoodsChart", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.extraLarge, dropShadow: true, cornerImage: Image(systemName: "chart.bar.xaxis"), animatedToBack: false)

