//
//  AppBackgroundView.swift
//  FindMyStuff
//
//  Created by Shruti Soni on 29/07/25.
//

import SwiftUI

struct AppBackgroundView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            content()
        }
    }
}

