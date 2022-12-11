//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.4739,
            longitude: 84.93953),
        span: MKCoordinateSpan(
            latitudeDelta: 0.015,
            longitudeDelta: 0.015))
    
    var body: some View {
        ZStack {
            mapView
            VStack {
                LogoView()
                    .shadow(radius: 10)
                Spacer()
            }
        }
    }
}

extension LocationMapView {
    private var mapView: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
    }
}

struct LogoView: View {
    var body: some View {
        Image("ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(height: 75)
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
