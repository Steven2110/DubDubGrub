//
//  OnboardingView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 16.01.2023.
//

import SwiftUI

struct OnboardView: View {
    
    @Binding var isShowingOnboardView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isShowingOnboardView = false
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.brandPrimary)
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .imageScale(.small)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding()
            }
            Spacer()
            LogoView(frameWidth: 250)
                .padding(.bottom)
            VStack(alignment: .leading, spacing: 35){
                OnboardViewInfoView(imageName: "building.2.crop.circle", title: "Restaurant Locations", description: "Find places to dine around the convention center")
                OnboardViewInfoView(imageName: "checkmark.circle", title: "Check In", description: "Let other iOS Devs know where you are")
                OnboardViewInfoView(imageName: "person.2.circle", title: "Find Friends", description: "See where other iOS Devs are and join the party")
            }
            .padding(.horizontal, 30)
            Spacer()
        }
    }
}

struct OnboardViewInfoView: View {
    
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(spacing: 25) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.brandPrimary)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.bold)
                Text(description)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(isShowingOnboardView: .constant(true))
    }
}
