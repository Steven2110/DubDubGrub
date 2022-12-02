//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI

struct LocationListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { i in
                    NavigationLink {
                        Text("Test location \(i)")
                    } label: {
                        HStack {
                            Image("default-square-asset")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                                .clipShape(Circle())
                                .padding(.vertical, 5)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Location name")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.75)
                                }
                                HStack {
                                    switch i {
                                    case 0:
                                        ForEach(0..<4) { _ in
                                            AvatarView()
                                        }
                                    case 1:
                                        ForEach(0..<5) { _ in
                                            AvatarView()
                                        }
                                    case 2:
                                        ForEach(0..<1) { _ in
                                            AvatarView()
                                        }
                                    case 3:
                                        ForEach(0..<2) { _ in
                                            AvatarView()
                                        }
                                    case 4:
                                        Text("Nobody Checked In")
                                            .foregroundColor(.secondary)
                                    default:
                                        AvatarView()
                                    }
                                }
                            }
                            .padding(.leading)
                        }
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

struct AvatarView: View {
    var body: some View {
        Image("default-avatar")
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35)
            .clipShape(Circle())
    }
}
