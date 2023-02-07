//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 07.02.2023.
//

import SwiftUI

struct ProfileModalView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 50)
                Text("Steven Wijaya")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text("iOS Developer")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                Text("This is my bio. I create an amazing app, that will blow up the world")
                    .lineLimit(3)
                    .padding()
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .overlay(
                Button {
                    // dismiss
                } label: {
                    DismissButton()
                }, alignment: .topTrailing
            )
            
            AvatarView(image: ImagePlaceHolder.avatar, size: 120)
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
        }
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView()
    }
}
