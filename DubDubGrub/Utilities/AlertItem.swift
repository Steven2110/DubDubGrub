//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 10.01.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id: UUID = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    //MARK: - MapView Errors
    static let unableToGetLocations: AlertItem = AlertItem(
        title: Text("Locations error"),
        message: Text("Unable to retrieve locations at this time.\nPlease try again."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let locationRestricted: AlertItem = AlertItem(
        title: Text("Locations Restricted"),
        message: Text("Your location is restricted. This may be due to parental controls."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let locationDenied: AlertItem = AlertItem(
        title: Text("Locations Denied"),
        message: Text("Dub Dub Grub does not have permission to access your location. To change that go to your phone's Settings > Dub Dub Grub > Location"),
        dismissButton: .default(Text("Ok"))
    )
    
    static let locationDisabled: AlertItem = AlertItem(
        title: Text("Locations Service Disabled"),
        message: Text("Your phone's location services are disabled. To change that go to your phone's Settings > Privacy > Location Services > On"),
        dismissButton: .default(Text("Ok"))
    )
}
