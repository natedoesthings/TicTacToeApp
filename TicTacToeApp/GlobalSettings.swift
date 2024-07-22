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
    @Published var primary: CodableColor = CodableColor(color: Color(.sRGB, red: 1, green: 1, blue: 1))
    @Published var secondary: CodableColor = CodableColor(color: Color(.sRGB, red: 0, green: 0, blue: 0))
    @Published var accents: CodableColor = CodableColor(color: Color(red: 245/255, green: 245/255, blue: 245/255))


    // Sound
    @Published var soundManager:SoundManager = SoundManager.shared
    
    
    enum CodingKeys: String, CodingKey {
            case mainVolume, musicVolume, effectsVolume
            case mainMute, musicMute, effectsMute
            case playerXSymbol, playerOSymbol
            case useDefaultX, useDefaultO
            case connected
            case symbolSize
            case darkMode
            case primary, secondary, accents
        }
    
    
    
    func reverseBlack() -> Color {
        return darkMode ? Color.white : secondary.color
    }
    
    func reverseWhite() -> Color {
        return darkMode ? Color.black : primary.color
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
    
    func resetSettings() {
        mainVolume = 0.5
        musicVolume = 0.5
        effectsVolume = 0.5
        
        mainMute = false
        musicMute = false
        effectsMute = false
        
        // Game Design Section
        playerXSymbol = "X"
        playerOSymbol = "O"

        useDefaultX = true
        useDefaultO = true
        
        connected = false
        symbolSize = 45

        
        // Theme Section
        darkMode = false
        primary = CodableColor(color: Color(.sRGB, red: 1, green: 1, blue: 1))
        secondary = CodableColor(color: Color(.sRGB, red: 0, green: 0, blue: 0))
        accents = CodableColor(color: Color(.sRGB, red: 245/255, green: 245/255, blue: 245/255))


        // Sound
        soundManager.mainVolume = 0.5
        soundManager.effectsVolume = 0.5
        soundManager.musicVolume = 0.5
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
        primary = try container.decode(CodableColor.self, forKey: .primary)
        secondary = try container.decode(CodableColor.self, forKey: .secondary)
        accents = try container.decode(CodableColor.self, forKey: .accents)

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
        try container.encode(primary, forKey: .primary)
        try container.encode(secondary, forKey: .secondary)
        try container.encode(accents, forKey: .accents)
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


class CodableColor:ObservableObject, Codable {
    @Published var color: Color
    
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
    
    init(color: Color) {
        self.color = color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let opacity = try container.decode(Double.self, forKey: .opacity)
        
        color = Color(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let components = color.cgColor?.components
        let red = components?[0] ?? 0
        let green = components?[1] ?? 0
        let blue = components?[2] ?? 0
        let opacity = components?[3] ?? 1
        
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(opacity, forKey: .opacity)
    }
}

extension Color {
    func isDark() -> Bool {
        // Convert Color to UIColor
        let uiColor = UIColor(self)
        
        // Get RGB components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate luminance
        // Formula: 0.299 * red + 0.587 * green + 0.114 * blue
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        
        // Return true if luminance is less than 0.5
        return luminance < 0.5
    }
}
    
    



