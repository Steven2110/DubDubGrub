//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 06.02.2023.
//

import CloudKit
import SwiftUI

enum ProfileContext {
    case create, update
}

final class ProfileViewModel: ObservableObject {
    
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var position: String = ""
    @Published var bioText: String = ""
    @Published var avatar = ImagePlaceHolder.avatar
    
    @Published private var locationName: String = ""
    
    @Published var isShowingPhotoPicker: Bool = false
    @Published var isLoading: Bool = false
    @Published var isCheckedIn: Bool = false
    
    @Published var alertItem: AlertItem?
    
    private var currentProfileRecord: CKRecord? {
        didSet { profileContext = .update }
    }
    
    var profileContext: ProfileContext = .create
    
    func getCheckedInStatus() {
        // Retrieve DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    if record[DDGProfile.cIsCheckedIn] is CKRecord.Reference {
                        isCheckedIn = true
                    } else {
                        isCheckedIn = false
                        print("isCheckedIn = false - reference is nil")
                    }
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckInStatus
                    print("Failed To Fetch Record ‼️")
                }
            }
        }
    }
    
    func checkOut() {
        // Retrieve DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                // Fetch location name where user checked in
                let locationReference: CKRecord.Reference = record[DDGProfile.cIsCheckedIn] as! CKRecord.Reference
                getCheckedInLocationName(fromRecordID: locationReference.recordID)
                // Make the reference nil so that user are not checked in on any place
                record[DDGProfile.cIsCheckedIn] = nil
                // Save update profile to CloudKit
                CloudKitManager.shared.save(record: record) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success(_):
                            isCheckedIn = false
                            alertItem = AlertItem(
                                title: Text("Check Out Successfully"),
                                message: Text("You have been check out from ~\(locationName)~.\nSee you again later here 👋"),
                                dismissButton: .default(Text("Ok")))
                            print("Checked Out Successfully ✅")
                        case .failure(_):
                            alertItem = AlertContext.unableToCheckInOut
                            print("Error Saving Record ‼️")
                        }
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.alertItem = AlertContext.unableToCheckInOut
                    print("Error Ferching Record ‼️")
                }
            }
        }
    }
    
    func getCheckedInLocationName(fromRecordID locationID: CKRecord.ID) {
        CloudKitManager.shared.fetchRecord(with: locationID) { result in
            switch result {
            case .success(let record):
                self.locationName = record[DDGLocation.cName] as! String
            case .failure(_):
                break
            }
        }
    }
    
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
        
        // Refactor network call using Singleton class CloudKitManager
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        // Create reference on UserRecord to the DDGProfile
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        showLoadingView()
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                
                switch result {
                case .success(let records):
                    for record in records where record.recordType == RecordType.profile {
                        currentProfileRecord = record
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
                    alertItem = AlertContext.createProfileSuccess
                case .failure(_):
                    alertItem = AlertContext.createProfileFailure
                }
            }
        }
        
        /*
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
         */
    }
    
    func getProfile() {
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
        
        let profilRecordID = profileReference.recordID
        
        showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profilRecordID) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(let record):
                    currentProfileRecord = record
                    
                    let profile = DDGProfile(record: record)
                    firstName = profile.firstName
                    lastName = profile.lastName
                    position = profile.position
                    bioText = profile.bio
                    avatar = profile.createAvatarImage()
                case .failure(_):
                    alertItem = AlertContext.unableToGetProfile
                    break
                }
            }
        }
        
        /*
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
        */
    }
    
    func updateProfile() {
        // Make sure that profile form values are valid
        guard checkProfileValidity() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        // Retrieve the existing profile record
        guard let profileRecord = currentProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        // Update the value (CloudKit will only update the changed values)
        profileRecord[DDGProfile.cFirstName] = firstName
        profileRecord[DDGProfile.cLastName] = lastName
        profileRecord[DDGProfile.cPosition] = position
        profileRecord[DDGProfile.cBio] = bioText
        profileRecord[DDGProfile.cAvatar] = avatar.convertToCKAsset()
        
        showLoadingView()
        CloudKitManager.shared.save(record: profileRecord) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(_):
                    alertItem = AlertContext.updateProfileSuccess
                case .failure(_):
                    alertItem = AlertContext.updateProfileFailure
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
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
