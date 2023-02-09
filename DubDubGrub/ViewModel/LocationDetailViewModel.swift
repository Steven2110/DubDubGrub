//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 07.02.2023.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus {
    case checkedIn, checkedOut
}

final class LocationDetailViewModel: ObservableObject {
    
    var location: DDGLocation
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var alertItem: AlertItem?
    
    @Published var checkedInProfiles: [DDGProfile] = []
    
    @Published var isLoading: Bool = false
    @Published var isShowingProfileModal: Bool = false
    @Published var isCheckedIn: Bool = false
    
    init(location: DDGLocation) {
        self.location = location
    }
    
    func getDirections() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // Show alert when device can't call
        }
    }
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus) {
        // Retrieve DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                // Create reference to the location
                switch checkInStatus {
                case .checkedIn:
                    record[DDGProfile.cIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                case .checkedOut:
                    record[DDGProfile.cIsCheckedIn] = nil
                }
                
                // Save update profile to CloudKit
                CloudKitManager.shared.save(record: record) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success(let record):
                            let profile = DDGProfile(record: record)
                            // Update checked in user array
                            switch checkInStatus {
                            case .checkedIn:
                                checkedInProfiles.append(profile)
                            case .checkedOut:
                                checkedInProfiles.removeAll(where: { $0.id == profile.id })
                            }
                            isCheckedIn = checkInStatus == .checkedIn
                            print("Checked In/Out Successfully ✅")
                        case .failure(_):
                            alertItem = AlertContext.updateProfileFailure
                            print("Error Saving Record ‼️")
                        }
                    }
                }
            case .failure(_):
                alertItem = AlertContext.unableToCheckInOut
                print("Error Ferching Record ‼️")
            }
        }
    }
    
    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profiles):
                    checkedInProfiles = profiles
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckInProfiles
                    print("Error Fetching CheckedIn Profiles ‼️")
                }
                
                hideLoadingView()
            }
        }
    }
    
    func getCheckedInStatus() {
        // Retrieve DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    if let reference = record[DDGProfile.cIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = reference.recordID == location.id
                        
                        /* if reference.recordID == location.id {
                            isCheckedIn = true
                            print("isCheckedIn = true")
                        } else {
                            isCheckedIn = false
                            print("isCheckedIn = false")
                        } */
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
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
