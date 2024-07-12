//
//  GlobalSettings.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/9/24.
//

import Foundation
import SwiftUI
import Combine

class GlobalSettings: ObservableObject, Codable {
    // Volume Section
    @Published var mainVolume: Double = 0.5
    @Published var musicVolume: Double = 0.5
    @Published var effectsVolume: Double = 0.5
    
    @Published var mainMute: Bool = false
    @Published var musicMute: Bool = false
    @Published var effectsMute: Bool = false
    
    // Game Design Section
    @Published var playerXSymbol: String = "X"
    @Published var playerOSymbol: String = "O"

    @Published var useDefaultX: Bool = true
    @Published var useDefaultO: Bool = true
    
    @Published var connected: Bool = false
    
    @Published var symbolSize: Double = 45

    
    // Theme Section
    @Published var darkMode: Bool = false
//    @Published var colorShifter: Int = 0

    
    // Sound
    @Published var soundManager:SoundManager = SoundManager.shared

    @Published var showRestartButton: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
            case mainVolume, musicVolume, effectsVolume
            case mainMute, musicMute, effectsMute
            case playerXSymbol, playerOSymbol
            case useDefaultX, useDefaultO
            case connected
            case symbolSize
            case darkMode
//            case gameDone
        }
    
    
    func updateRestart() {
        showRestartButton = !showRestartButton
        print(showRestartButton)
    }
    
    func reverseBlack() -> Color {
        return darkMode ? Color.white : Color.black
    }
    
    func reverseWhite() -> Color {
        return darkMode ? Color.black : Color.white
    }
    
    func playTheme() {
        if !mainMute {
            soundManager.mainVolume = mainVolume
        }
        else {
            soundManager.mainVolume = 0
        }
        
        soundManager.updateVolume(for: .main)
        
        
        if !musicMute {
            soundManager.musicVolume = musicVolume

        }
        else {
            soundManager.musicVolume = 0
        }
        
        soundManager.updateVolume(for: .music)
        
        if !effectsMute {
            soundManager.effectsVolume = effectsVolume
        }
        else {
            soundManager.effectsVolume = 0
        }
        
        soundManager.updateVolume(for: .effects)
        
        soundManager.playSound(named: "MainMenuTrack", loop: true, volumeType: .music)

        
        
    }
    
    func validateX() {
        useDefaultX = !(playerXSymbol.count == 1 && playerXSymbol != playerOSymbol)
        playerXSymbol = useDefaultX ? "X" : playerXSymbol
        
    }
    
    func validateO() {
        useDefaultO = !(playerOSymbol.count == 1 && playerXSymbol != playerOSymbol)
        playerOSymbol = useDefaultO ? "O" : playerOSymbol
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mainVolume = try container.decode(Double.self, forKey: .mainVolume)
        musicVolume = try container.decode(Double.self, forKey: .musicVolume)
        effectsVolume = try container.decode(Double.self, forKey: .effectsVolume)
        mainMute = try container.decode(Bool.self, forKey: .mainMute)
        musicMute = try container.decode(Bool.self, forKey: .musicMute)
        effectsMute = try container.decode(Bool.self, forKey: .effectsMute)
        playerXSymbol = try container.decode(String.self, forKey: .playerXSymbol)
        playerOSymbol = try container.decode(String.self, forKey: .playerOSymbol)
        useDefaultX = try container.decode(Bool.self, forKey: .useDefaultX)
        useDefaultO = try container.decode(Bool.self, forKey: .useDefaultO)
        connected = try container.decode(Bool.self, forKey: .connected)
        symbolSize = try container.decode(Double.self, forKey: .symbolSize)
        darkMode = try container.decode(Bool.self, forKey: .darkMode)
//        gameDone = try container.decode(Bool.self, forKey: .gameDone)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mainVolume, forKey: .mainVolume)
        try container.encode(musicVolume, forKey: .musicVolume)
        try container.encode(effectsVolume, forKey: .effectsVolume)
        try container.encode(mainMute, forKey: .mainMute)
        try container.encode(musicMute, forKey: .musicMute)
        try container.encode(effectsMute, forKey: .effectsMute)
        try container.encode(playerXSymbol, forKey: .playerXSymbol)
        try container.encode(playerOSymbol, forKey: .playerOSymbol)
        try container.encode(useDefaultX, forKey: .useDefaultX)
        try container.encode(useDefaultO, forKey: .useDefaultO)
        try container.encode(connected, forKey: .connected)
        try container.encode(symbolSize, forKey: .symbolSize)
        try container.encode(darkMode, forKey: .darkMode)
//        try container.encode(gameDone, forKey: .gameDone)
    }

    init() {}
}



extension GlobalSettings {
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "GlobalSettings")
        }
    }

    static func load() -> GlobalSettings {
        if let savedData = UserDefaults.standard.data(forKey: "GlobalSettings"),
           let decodedSettings = try? JSONDecoder().decode(GlobalSettings.self, from: savedData) {
            return decodedSettings
        }
        return GlobalSettings()
    }
}
    
    



