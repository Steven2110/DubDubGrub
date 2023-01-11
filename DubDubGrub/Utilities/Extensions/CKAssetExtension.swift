//
//  CKAssetExtension.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 11.01.2023.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        let placeholder = ImageDimension.getPlaceHolder(for: dimension)
        
        guard let fileUrl = self.fileURL else { return placeholder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? placeholder
        } catch {
            return placeholder
        }
    }
}
