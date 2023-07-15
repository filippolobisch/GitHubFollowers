//
//  GFButtonView.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 13.07.23.
//

import SwiftUI

struct GFButtonView: View {
    var title: String
    var imageName: String
    
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(title)
        }
        .frame(height: 50)
    }
}

#Preview {
    GFButtonView(title: "Get Followers", imageName: "person.3.fill")
}
