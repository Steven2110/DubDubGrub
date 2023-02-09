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
    
    @Published var isShowingProfileModal: Bool = false
    
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
                    switch result {
                    case .success(_):
                        // Update checked in user array
                        print("Checked In/Out Successfully ✅")
                    case .failure(_):
                        print("Error Saving Record ‼️")
                    }
                }
            case .failure(_):
                print("Error Ferching Record ‼️")
            }
        }
    }
}
