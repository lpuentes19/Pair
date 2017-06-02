//
//  Pair.swift
//  Pair
//
//  Created by Luis Puentes on 6/2/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import CloudKit

class Pair {
    
    static let typeKey = "Pair"
    static let namesKey = "Name"
    
    var names: String
    
    init(names: String) {
        
        self.names = names
    }
    
    var cloudKitRecordID: CKRecordID?
    
    init?(cloudKitRecord: CKRecord) {
        guard let names = cloudKitRecord[Pair.namesKey] as? String else { return nil }
        
        self.names = names
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
    
    var cloudKitRecord: CKRecord {
        
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: Pair.typeKey, recordID: recordID)
        
        record.setValue(names, forKey: Pair.namesKey)
        
        self.cloudKitRecordID = recordID
        
        return record
    }
}
