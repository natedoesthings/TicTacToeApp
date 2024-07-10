//
//  TicTacToeAppApp.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/5/24.
//

import SwiftUI

@main
struct TicTacToeAppApp: App {
    @StateObject private var globalSettings = GlobalSettings()
    @StateObject private var globalSound = GlobalSound()
    
    init() {
        globalSettings.playTheme()
    }

    var body: some Scene {
        
        WindowGroup {
            MainMenuView()
                .environmentObject(globalSettings)
                .environmentObject(globalSound)
        }
    }
}


struct BackgroundColorModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .background(color.edgesIgnoringSafeArea(.all))
    }
}

extension View {
    func applyBackgroundColor(_ color: Color) -> some View {
        self.modifier(BackgroundColorModifier(color: color))
    }
}
