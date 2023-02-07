//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 07.02.2023.
//

import SwiftUI

struct ProfileModalView: View {
    
    var profile: DDGProfile
    
    @Binding var isShowingProfileModalView: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 50)
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(profile.position)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                Text(profile.bio)
                    .lineLimit(3)
                    .padding()
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .overlay(
                Button {
                    // dismiss
                    withAnimation {
                        isShowingProfileModalView = false
                    }
                } label: {
                    DismissButton()
                }, alignment: .topTrailing
            )
            
            AvatarView(image: profile.createAvatarImage(), size: 120)
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
        }
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(profile: DDGProfile(record: MockData.profile), isShowingProfileModalView: .constant(true))
    }
}
