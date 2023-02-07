//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink {
                        LocationDetailView(viewModel: LocationDetailViewModel(location: location))
                    } label: {
                        LocationRowView(location: location)
                    }
                }
            }
            .navigationTitle("Grub Spots")
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
            .environmentObject(LocationManager())
    }
}
