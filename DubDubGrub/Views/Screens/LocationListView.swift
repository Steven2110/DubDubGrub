//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI

struct LocationListView: View {
    
    @State private var locations: [DDGLocation] = [DDGLocation(record: MockData.location)]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(locations, id: \.ckRecordID) { location in
                    NavigationLink {
                        LocationDetailView(location: location)
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
    }
}
