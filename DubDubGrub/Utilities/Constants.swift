//
//  Constants.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 10.01.2023.
//

import UIKit

enum RecordType {
    static let location = "DDGLocation"
    static let profile = "DDGProfile"
}

enum ImagePlaceHolder {
    static let avatar = UIImage(named: "default-avatar")!
    static let banner = UIImage(named: "default-banner-asset")!
    static let square = UIImage(named: "default-square-asset")!
}

enum ImageDimension {
    case square, banner
    
    static func getPlaceHolder(for dimension: ImageDimension) -> UIImage {
        switch dimension {
        case .square:
            return ImagePlaceHolder.square
        case .banner:
            return ImagePlaceHolder.banner
        }
    }
}
