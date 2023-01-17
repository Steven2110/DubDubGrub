//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 12.12.2022.
//

import SwiftUI

struct AvatarView: View {
    
    var image: UIImage
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}


struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(image: ImagePlaceHolder.avatar, size: 50)
    }
}
