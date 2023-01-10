//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @StateObject private var viewModel = LocationMapViewModel()
    
    var body: some View {
        ZStack {
            mapView
            VStack {
                LogoView()
                    .shadow(radius: 10)
                Spacer()
            }
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .onAppear {
            viewModel.getLocations()
        }
    }
}

extension LocationMapView {
    private var mapView: some View {
        Map(coordinateRegion: $viewModel.region)
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
