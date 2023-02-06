//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 06.02.2023.
//

import CloudKit

final class ProfileViewModel: ObservableObject {
    
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var position: String = ""
    @Published var bioText: String = ""
    @Published var avatar = ImagePlaceHolder.avatar
    
    @Published var isShowingPhotoPicker: Bool = false
    
    @Published var alertItem: AlertItem?
    
    func checkProfileValidity() -> Bool {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !position.isEmpty,
              !bioText.isEmpty,
              avatar != ImagePlaceHolder.avatar,
              bioText.count <= 100
        else { return false }
        
        return true
    }
    
    func createProfile() {
        guard checkProfileValidity() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        // Create CKRecord from profile form
        let profileRecord = createProfileRecord()
        
        // Get UserRecordID from container
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
                
                // Create reference on UserRecord to the DDGProfile
                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                
                // Create CKOperation to save User and Profile Records
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])
                operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordsID, error in
                    guard let savedRecords = savedRecords, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    print(savedRecords)
                }
                
                CKContainer.default().publicCloudDatabase.add(operation) // Same as `task.resume()`
            }
        }
    }
    
    func getProfile() {
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
                
                let profileReference = userRecord["userProfile"] as! CKRecord.Reference
                let profilRecordID = profileReference.recordID
                
                CKContainer.default().publicCloudDatabase.fetch(withRecordID: profilRecordID) { profileRecord, error in
                    guard let profileRecord = profileRecord, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.async { [self] in
                        let profile = DDGProfile(record: profileRecord)
                        firstName = profile.firstName
                        lastName = profile.lastName
                        position = profile.position
                        bioText = profile.bio
                        avatar = profile.createAvatarImage()
                    }
                }
            }
        }
    }
    
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.cFirstName] = firstName
        profileRecord[DDGProfile.cLastName] = lastName
        profileRecord[DDGProfile.cPosition] = position
        profileRecord[DDGProfile.cBio] = bioText
        profileRecord[DDGProfile.cAvatar] = avatar.convertToCKAsset()
        
        return profileRecord
    }
}
