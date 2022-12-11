//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var position: String = ""
    @State private var bioText: String = ""
    
    var body: some View {
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
                
            } label: {
                DDGButton(title: "Save Profile")
                    .padding()
            }
        }
        .navigationTitle("Profile")
    }
}

extension ProfileView {
    private var profileDataBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color(.secondarySystemBackground))
            .frame(height: 150)
    }
    
    private var profileFirstName: some View {
        TextField("First Name", text: $firstName)
    }
    
    private var profileLastName: some View {
        TextField("Last Name", text: $lastName)
    }
    
    private var profilePosition: some View {
        TextField("Position", text: $position)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
    
    private var profileImage: some View {
        ZStack {
            AvatarView(size: 90)
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y: 33)
        }
    }
    
    private var bioCharactersRemain: some View {
        Group {
            Text("Bio: ")
            +
            Text("\(100 - bioText.count)")
                .foregroundColor(bioText.count <= 100 ? .brandPrimary : .pink)
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
        TextEditor(text: $bioText)
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
