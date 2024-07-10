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
    
    @Published var connected: Bool = false
    
    @Published var symbolSize: Double = 45

    
    // Theme Section
    @Published var darkMode: Bool = false
//    @Published var colorShifter: Int = 0

    
    // Sound
    @Published var soundManager:SoundManager = SoundManager.shared

    @Published var gameDone: Bool = false

    
    init() {
        validateO()
        validateX()
    }
    
    func reverseBlack() -> Color {
        return darkMode ? Color.white : Color.black
    }
    
    func reverseWhite() -> Color {
        return darkMode ? Color.black : Color.white
    }
    
    func playTheme() {
        if mainMute == false {
            soundManager.playSound(named: "MainMenuTrack", loop: true, volumeType: .music)
        }
    }
    
    func validateX() {
        useDefaultX = !(playerXSymbol.count == 1 && playerXSymbol != playerOSymbol)
        playerXSymbol = useDefaultX ? "X" : playerXSymbol
    }
    
    func validateO() {
        useDefaultO = !(playerOSymbol.count == 1 && playerXSymbol != playerOSymbol)
        playerOSymbol = useDefaultO ? "O" : playerOSymbol
    }
    
    
    
    
}


