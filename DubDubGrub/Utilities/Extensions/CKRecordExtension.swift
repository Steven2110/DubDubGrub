//
//  CKRecordExtension.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 10.01.2023.
//

import CloudKit

extension CKRecord {
    func convertToDDGLocation() -> DDGLocation { DDGLocation(record: self) }
    
    func convertToDDGProfile() -> DDGProfile { DDGProfile(record: self) }
}
