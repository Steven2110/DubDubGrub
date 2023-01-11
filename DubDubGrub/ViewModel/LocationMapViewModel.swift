//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 10.01.2023.
//

import MapKit

final class LocationMapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.4739,
            longitude: 84.93953),
        span: MKCoordinateSpan(
            latitudeDelta: 0.015,
            longitudeDelta: 0.015))
    
    @Published var alertItem: AlertItem?
    
    func getLocations(for locationManager: LocationManager) {
        CloudKitManager.getLocations { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let locations):
                    locationManager.locations = locations
                case .failure(_):
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
}
