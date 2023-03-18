//
//  HealthStore.swift
//  Calendar data fetching
//
//  Created by Jakub Jelinek on 08/03/2023.
//

import Foundation
import HealthKit

class HealthStore: ObservableObject {
    
    private let healthStore = HKHealthStore()
    private let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    
    @Published var authorized = false
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToShare: Set<HKSampleType>? = []
        let typesToRead: Set = [hrvType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.authorized = success
                completion(success)
            }
        }
    }
    
    func getHRVData(completion: @escaping ([Double]) -> Void) {
        guard let sampleType = hrvType as? HKQuantityType else {
            completion([])
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let samples = samples as? [HKQuantitySample] {
                let hrvSamples = samples.map { sample in
                    sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                }
                completion(hrvSamples)
            } else {
                completion([])
            }
        }
        healthStore.execute(query)
    }
}

