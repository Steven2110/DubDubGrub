//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 02.12.2022.
//

import SwiftUI

struct LocationDetailView: View {
    
    var location: DDGLocation
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            bannerImage
            HStack {
                Label(location.address, systemImage: "mappin.and.ellipse")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
            }
            .padding(.leading)
            .padding(.top, 3)
            description
            ZStack {
                capsuleBackground
                HStack(spacing: 25) {
                    Button {
                        
                    } label: {
                        LocationButtonLabel(color: Color.brandPrimary, imageName: "location.fill")
                    }
                    Link(destination: URL(string: location.websiteURL)!, label: {
                        LocationButtonLabel(color: Color.brandPrimary, imageName: "globe")
                    })
                    Button {
                        
                    } label: {
                        LocationButtonLabel(color: Color.brandPrimary, imageName: "phone.fill")
                    }
                    Button {
                        
                    } label: {
                        LocationButtonLabel(color: Color.brandPrimary, imageName: "person.fill.checkmark")
                    }
                }
                .font(.title3)
            }
            Text("Who's Here?")
                .fontWeight(.bold)
                .font(.title3)
                .padding()
            ScrollView {
                LazyVGrid(columns: columns) {
                    AvatarFirstNameView(firstName: "John")
                    AvatarFirstNameView(firstName: "John")
                    AvatarFirstNameView(firstName: "John")
                    AvatarFirstNameView(firstName: "John")
                }
            }
            Spacer()
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationDetailView(location: DDGLocation(record: MockData.location))
        }
    }
}

extension LocationDetailView {
    private var bannerImage: some View {
        Image(uiImage: location.createBannerImage())
            .resizable()
            .scaledToFill()
            .frame(height: 120)
    }
    
    private var description: some View {
        Text(location.description)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
    
    private var capsuleBackground: some View {
        Capsule()
            .frame(height: 80)
            .foregroundColor(Color(.secondarySystemBackground))
            .padding(.horizontal)
    }
}

struct LocationButtonLabel: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .accentColor(.white)
        }
    }
}

struct AvatarFirstNameView: View {
    
    var firstName: String
    
    var body: some View {
        VStack {
            AvatarView(size: 64)
            Text(firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}
