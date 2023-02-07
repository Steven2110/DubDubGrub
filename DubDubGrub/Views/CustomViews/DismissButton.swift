//
//  DismissButton.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 07.02.2023.
//

import SwiftUI

struct DismissButton: View {
    var body: some View {
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
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
