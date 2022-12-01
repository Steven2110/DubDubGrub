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
            logo
        }
    }
}

extension LocationMapView {
    private var mapView: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
    }
    private var logo: some View {
        VStack {
            Image("ddg-map-logo")
                .resizable()
                .scaledToFit()
                .frame(height: 75)
                .shadow(radius: 10)
            Spacer()
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
