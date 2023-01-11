//
//  DDGLocation.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 12.12.2022.
//

import Foundation
import CloudKit
import UIKit

struct DDGLocation: Identifiable {
    let id: CKRecord.ID
    
    let name: String
    let description: String
    let address: String
    let location: CLLocation
    let websiteURL: String
    let phoneNumber: String
    
    let squareAsset: CKAsset!
    let bannerAsset: CKAsset!
    
    static let cName = "name"
    static let cDescription = "description"
    static let cAddress = "address"
    static let cLocation = "location"
    static let cWebsiteURL = "websiteUrl"
    static let cPhoneNumber = "phoneNumber"
    static let cSquareAsset = "squareAsset"
    static let cBannerAsset = "bannerAsset"
    
    init(record: CKRecord) {
        id = record.recordID
        name = record[DDGLocation.cName] as? String ?? "N/A"
        description = record[DDGLocation.cDescription] as? String ?? "N/A"
        address = record[DDGLocation.cAddress] as? String ?? "N/A"
        location = record["location"] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        websiteURL = record[DDGLocation.cWebsiteURL] as? String ?? "N/A"
        phoneNumber = record[DDGLocation.cPhoneNumber] as? String ?? "N/A"
        
        squareAsset = record[DDGLocation.cSquareAsset] as? CKAsset
        bannerAsset = record[DDGLocation.cBannerAsset] as? CKAsset
    }
    
    func createSquareImage() -> UIImage {
        guard let asset = squareAsset else { return ImagePlaceHolder.square }
        return asset.convertToUIImage(in: .square)
    }
    
    func createBannerImage() -> UIImage {
        guard let asset = bannerAsset else { return ImagePlaceHolder.banner }
        return asset.convertToUIImage(in: .banner)
    }
}
