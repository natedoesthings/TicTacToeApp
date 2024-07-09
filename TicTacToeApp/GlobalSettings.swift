//
//  GlobalSettings.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/9/24.
//

import Foundation
import SwiftUI
import Combine

class GlobalSettings: ObservableObject {
    // Volume Section
    @Published var mainVolume: Double = 0.5
    @Published var musicVolume: Double = 0.5
    @Published var effectsVolume: Double = 0.5
    
    @Published var mainMute: Bool = false
    @Published var musicMute: Bool = false
    @Published var effectsMute: Bool = false
    
    // Game Design Section
    @Published var playerXSymbol: String = ""
    @Published var playerOSymbol: String = ""
    
    @Published var useDefaultX: Bool = false
    @Published var useDefaultO: Bool = false
    
    // Theme Section
    @Published var darkMode: Bool = false
    
    
    func reverseBlack() -> Color {
        return darkMode ? Color.white : Color.black
    }
    
    func reverseWhite() -> Color {
        return darkMode ? Color.black : Color.white
    }
    
//    func mute(volumeType: VolumeType) {
//        
//    }
    
    
}
