//
//  DDGProfile.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 12.12.2022.
//

import UIKit
import CloudKit

struct DDGProfile: Identifiable {
    let id: CKRecord.ID
    
    let firstName: String
    let lastName: String
    let position: String
    let bio: String
    let avatar: CKAsset!
    
    let isCheckedIn: CKRecord.Reference? = nil
    
    static let cFirstName = "firstName"
    static let cLastName = "lastName"
    static let cPosition = "position"
    static let cBio = "bio"
    static let cAvatar = "avatar"
    static let cIsCheckedIn = "isCheckedIn"
    
    init(record: CKRecord) {
        id = record.recordID
        firstName = record[DDGProfile.cFirstName] as? String ?? "First Name"
        lastName = record[DDGProfile.cLastName] as? String ?? "Last Name"
        position = record[DDGProfile.cPosition] as? String ?? "N/A"
        bio = record[DDGProfile.cBio] as? String ?? "N/A"
        avatar = record[DDGProfile.cAvatar] as? CKAsset
    }
    
    func createAvatarImage() -> UIImage {
        guard let avatar = avatar else {
            return ImagePlaceHolder.avatar
        }
        return avatar.convertToUIImage(in: .square)
    }
}

