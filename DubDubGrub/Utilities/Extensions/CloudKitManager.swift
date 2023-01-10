//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 10.01.2023.
//

import CloudKit

struct CloudKitManager {
    static func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> ()) {
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
}
