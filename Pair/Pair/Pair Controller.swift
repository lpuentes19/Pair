//
//  Pair Controller.swift
//  Pair
//
//  Created by Luis Puentes on 6/2/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import CloudKit

class PairController {
    
    static let shared = PairController()
    
    var names = [Pair]()
    var groups: [[Pair]] {
        return regroup(name: names)
    }
    
    // Save names to CloudKit
    func addName(name: String, completion: @escaping () -> Void) {
    
        let name = Pair(names: name)
        let nameRecord = name.cloudKitRecord
        
        CKContainer.default().publicCloudDatabase.save(nameRecord) { (record, error) in
            if let error = error {
                NSLog("Error saving name to CloudKit: \(error)")
            }
            self.names.append(name)
            completion()
        }
    }
    
    // Fetch from CloudKit
    func fetchName(completion: @escaping () -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Pair.typeKey, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                NSLog("Error fetching names from CloudKit: \(error)")
            }
            
            guard let record = record else { return }
            
            let names = record.flatMap { Pair(cloudKitRecord: $0) }
            self.names = names
            completion()
        }
    }
    
    // Delete from CloudKit
    func delete(name: Pair) {
        
        guard let index = names.index(of: name) else { return }
        self.names.remove(at: index)
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: name.cloudKitRecord.recordID) { (record, error) in
            if let error = error {
                NSLog("Error deleting name from CloudKit: \(error)")
            }
        }
    }
    
    // Regroup Method
    func regroup(name: [Pair]) -> [[Pair]] {
        let group = stride(from: 0, to: name.count, by: 2).map { Array(name[$0..<min($0 + 2, name.count)]) }
        return group
    }
    
}
