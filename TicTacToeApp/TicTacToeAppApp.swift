//
//  TicTacToeAppApp.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/5/24.
//

import SwiftUI
import UIKit

@main
struct TicTacToeAppApp: App {
    @StateObject private var globalSettings: GlobalSettings = GlobalSettings.load()

    init() {
        globalSettings.playTheme()
    }

    var body: some Scene {
        
        WindowGroup {
            MainMenuView()
                .environmentObject(globalSettings)
                .onReceive(globalSettings.objectWillChange, perform: { _ in
                    globalSettings.save()
                })
        }
    }
    
    
}




