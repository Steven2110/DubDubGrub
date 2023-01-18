//
//  UIIMageExtension.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 19.01.2023.
//

import CloudKit
import UIKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        
        // Get apps base document directory URL
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document Directory url came back nil")
            return nil
        }
        print(urlPath)
        
        // Append unique identifier for profile image
        let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
        
        // Write image data to the location the address point to
        guard let imageData = jpegData(compressionQuality: 0.25) else {
            return nil
        }
        
        // Create CKAsset with file URL
        do {
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
        
        return nil
    }
}
