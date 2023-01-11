//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 11.01.2023.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [DDGLocation] = []
}
