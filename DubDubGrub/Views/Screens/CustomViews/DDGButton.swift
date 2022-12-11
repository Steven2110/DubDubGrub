//
//  DDGButton.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 11.12.2022.
//

import SwiftUI

struct DDGButton: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .bold()
            .frame(height: 50)
            .frame(maxWidth: 300)
            .foregroundColor(.white)
            .background(Color.brandPrimary)
            .cornerRadius(10)
    }
}

struct DDGButton_Previews: PreviewProvider {
    static var previews: some View {
        DDGButton(title: "Save Me")
    }
}
