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
}
