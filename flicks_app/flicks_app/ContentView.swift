//  ContentView.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Ultra-minimal boilerplate implementation for SwiftUI layout.
//  This file defines the ContentView as the home screen for the Flicks! app, providing a basic structure.
//  It is designed as a starting point for future development with Domain and Data layers.
//  Future versions may add photo views, navigation, and interactions, requiring additional components and tests.
//

import SwiftUI

@MainActor
struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Text("FLICKS BETA")
                    .foregroundColor(.white)
                
                // Placeholder for main photo
                Color.gray
                    .frame(height: 200)
                
                // Placeholder for secondary photos
                ScrollView {
                    VStack {
                        Color.gray
                            .frame(height: 100)
                        Color.gray
                            .frame(height: 100)
                    }
                }
                
                // Placeholder for bottom navigation
                HStack {
                    Color.black
                    Color.red
                    Color.black
                }
                .frame(height: 50)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
