//
//  UserInfoViewProtocol.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 18.10.23.
//

import Foundation
import SwiftUI


protocol UserInfoViewProtocol: View {}

extension UserInfoViewProtocol{
    @MainActor func withUserInfoPadding() -> some View {
        modifier(UserInfoPadding())
    }
}

@MainActor
private struct UserInfoPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.quaternary)
            }
    }
}
