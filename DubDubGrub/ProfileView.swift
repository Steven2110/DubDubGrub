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
        NavigationView {
            VStack {
                profileData
                VStack {
                    HStack {
                        bioInformation
                        Spacer()
                        Button {
                            
                        } label: {
                            checkOutButtonLabel
                        }
                    }
                    .padding(.horizontal)
                    bioTextBox
                        .padding(.horizontal)
                }
                Spacer()
                Button {
                    
                } label: {
                    saveButtonLabel
                }
            }
            .navigationTitle("Profile")
        }
    }
}

extension ProfileView {
    var profileData: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.secondarySystemBackground))
                .frame(height: 150)
            HStack {
                profileImage
                VStack(alignment: .leading, spacing: 1) {
                    TextField("First Name", text: $firstName)
                        .font(.system(size: 32, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    TextField("Last Name", text: $lastName)
                        .font(.system(size: 32, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    TextField("Position", text: $position)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                Spacer()
            }
            .padding()
        }
        .padding()
    }
    
    var profileImage: some View {
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
    
    var bioInformation: some View {
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
    
    var checkOutButtonLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.red)
                .frame(width: 110,height: 30)
            Label("Check Out", systemImage: "mappin.and.ellipse")
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    var bioTextBox: some View {
        TextEditor(text: $bioText)
            .frame(height: 100)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 2)
            )
    }
    
    var saveButtonLabel: some View {
        Text("Save Profile")
            .bold()
            .frame(height: 50)
            .frame(maxWidth: 300)
            .foregroundColor(.white)
            .background(Color.brandPrimary)
            .cornerRadius(10)
            .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
