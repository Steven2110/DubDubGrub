//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    @StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    profileDataBackground
                    HStack {
                        profileImage
                        VStack {
                            profileFirstName
                                .profileNameStyle()
                            profileLastName
                                .profileNameStyle()
                            profilePosition
                        }
                        Spacer()
                    }
                    .padding()
                }
                .padding()
                VStack {
                    HStack {
                        bioCharactersRemain
                        Spacer()
                        Button {
                            
                        } label: {
                            checkOutButtonLabel
                        }
                    }
                    bioTextBox
                }
                .padding(.horizontal)
                Spacer()
                Button {
                    dismissKeyboard()
                    viewModel.createProfile()
                } label: {
                    DDGButton(title: "Save Profile")
                        .padding()
                }
            }
            
            if viewModel.isLoading { LoadingView() }
        }
        .navigationTitle("Profile")
        .toolbar {
            Button {
                dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
        .onAppear { viewModel.getProfile() }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .sheet(isPresented: $viewModel.isShowingPhotoPicker) {
            PhotoPicker(image: $viewModel.avatar)
        }
    }
}

extension ProfileView {
    private var profileDataBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color(.secondarySystemBackground))
            .frame(height: 150)
    }
    
    private var profileFirstName: some View {
        TextField("First Name", text: $viewModel.firstName)
    }
    
    private var profileLastName: some View {
        TextField("Last Name", text: $viewModel.lastName)
    }
    
    private var profilePosition: some View {
        TextField("Position", text: $viewModel.position)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
    
    private var profileImage: some View {
        ZStack {
            AvatarView(image: viewModel.avatar, size: 90)
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y: 33)
        }
        .onTapGesture {
            viewModel.isShowingPhotoPicker = true
        }
    }
    
    private var bioCharactersRemain: some View {
        Group {
            Text("Bio: ")
            +
            Text("\(100 - viewModel.bioText.count)")
                .foregroundColor(viewModel.bioText.count <= 100 ? .brandPrimary : .pink)
                .bold()
            +
            Text(" characters remain")
        }
        .font(.callout)
        .foregroundColor(.secondary)
    }
    
    private var checkOutButtonLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.red)
                .frame(width: 110,height: 30)
            Label("Check Out", systemImage: "mappin.and.ellipse")
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    private var bioTextBox: some View {
        TextEditor(text: $viewModel.bioText)
            .frame(height: 100)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 2)
            )
        
    }
    
    
    
    
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
