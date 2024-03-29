//
//  DDGTabView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI

struct DDGTabView: View {
    var body: some View {
        TabView {
            LocationMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            LocationListView()
                .tabItem {
                    Label("Locations", systemImage: "building.2")
                }
            NavigationView {
                ProfileView()
            }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .onAppear { CloudKitManager.shared.getUserRecord() }
        .accentColor(.brandPrimary)
    }
}

struct DubDubGrubTabView_Previews: PreviewProvider {
    static var previews: some View {
        DDGTabView()
    }
}
