//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 10.01.2023.
//

import CloudKit

// Make this as a singleton object
final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    private init() { }
    
    var userRecord: CKRecord?
    
    func getUserRecord() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            print("This is record ID from container: \(recordID)")
            
            // Get UserRecord from public database
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                print("This is user record from database: \(userRecord)")
                
                self.userRecord = userRecord
            }
        }
    }
    
    func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> ()) {
        // Create a sort descriptor to sort the response data from CKQuery
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.cName, ascending: true)
        // Initialize CKQuery
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        // Set the sort descriptors with our sortDescriptor
        query.sortDescriptors = [sortDescriptor]
 
        // To perform the query from default container and public database
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            // Check if we get an error and return error as failure of network call
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            // Guard our records
            guard let records = records else { return }
            
            let locations = records.map { $0.convertToDDGLocation() }
            
            // Pass and return our locations as completed network call
            completed(.success(locations))
        }
    }
    
    func batchSave(records: [CKRecord], completed: @escaping (Result<[CKRecord], Error>) -> Void) {
        // Create CKOperation to save User and Profile Records
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordsID, error in
            guard let savedRecords = savedRecords, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            print(savedRecords)
            completed(.success(savedRecords))
        }
        
        CKContainer.default().publicCloudDatabase.add(operation) // Same as `task.resume()`
    }
    
    func save(record: CKRecord, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
}
