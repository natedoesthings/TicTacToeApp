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

    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(globalSettings)
                .applyBackgroundColor(globalSettings.darkMode ? .white : .black)
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
