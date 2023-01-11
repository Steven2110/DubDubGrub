//
//  ViewExtension.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 11.12.2022.
//

import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
}
