//
//  LocationRowView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 11.12.2022.
//

import SwiftUI

struct LocationRowView: View {
    
    var location: DDGLocation
    
    var body: some View {
        HStack {
            Image("default-square-asset")
                .resizable()
                .scaledToFit()
                .frame(width: 90)
                .clipShape(Circle())
                .padding(.vertical, 5)
            VStack(alignment: .leading) {
                HStack {
                    Text(location.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                HStack {
                    AvatarView(size: 35)
                    AvatarView(size: 35)
                    AvatarView(size: 35)
                }
            }
            .padding(.leading)
        }
    }
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(location: DDGLocation(record: MockData.location))
    }
}
