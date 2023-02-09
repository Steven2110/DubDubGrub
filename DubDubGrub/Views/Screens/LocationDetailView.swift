//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 02.12.2022.
//

import SwiftUI

struct LocationDetailView: View {
    
    @ObservedObject var viewModel: LocationDetailViewModel
    
    var body: some View {
        ZStack {
            VStack {
                bannerImage
                HStack {
                    Label(viewModel.location.address, systemImage: "mappin.and.ellipse")
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
                            viewModel.getDirections()
                        } label: {
                            LocationButtonLabel(color: Color.brandPrimary, imageName: "location.fill")
                        }
                        Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
                            LocationButtonLabel(color: Color.brandPrimary, imageName: "globe")
                        })
                        Button {
                            viewModel.callLocation()
                        } label: {
                            LocationButtonLabel(color: Color.brandPrimary, imageName: "phone.fill")
                        }
                        Button {
                            viewModel.updateCheckInStatus(to: .checkedOut)
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
                    LazyVGrid(columns: viewModel.columns) {
                        AvatarFirstNameView(firstName: "John")
                            .onTapGesture {
                                viewModel.isShowingProfileModal = true
                            }
    //                    AvatarFirstNameView(firstName: "John")
    //                    AvatarFirstNameView(firstName: "John")
    //                    AvatarFirstNameView(firstName: "John")
                    }
                }
                Spacer()
            }
            
            if viewModel.isShowingProfileModal {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.95)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                ProfileModalView(profile: DDGProfile(record: MockData.profile), isShowingProfileModalView: $viewModel.isShowingProfileModal)
                    .transition(.opacity.combined(with: .slide))
                    .animation(.easeOut)
                    .zIndex(2)
            }
        }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.location)))
        }
    }
}

extension LocationDetailView {
    private var bannerImage: some View {
        Image(uiImage: viewModel.location.createBannerImage())
            .resizable()
            .scaledToFill()
            .frame(height: 120)
    }
    
    private var description: some View {
        Text(viewModel.location.description)
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
            AvatarView(image: ImagePlaceHolder.avatar, size: 64)
            Text(firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}
