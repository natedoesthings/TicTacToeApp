//
//  GameModeSelectionView.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/7/24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    @State private var animateButton = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalSettings: GlobalSettings
//    @EnvironmentObject var globalSound: GlobalSound


    var body: some View {
        ZStack{
            globalSettings.reverseWhite().ignoresSafeArea()
            ScrollView {
                
                VStack {
                    
                    Text("Settings")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(globalSettings.reverseBlack())
                    
                    // Volume Section
                    // First Game Design Options Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Volume Control")
                            .font(.headline)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(globalSettings.reverseBlack())// Align text to the left
                        
                        VStack {
                            HStack() {
                                Text("Main")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                    .foregroundColor(globalSettings.reverseBlack())
                                
                                Slider(value: $globalSettings.soundManager.mainVolume, in: 0...1, step: 0.01)
                                    .accentColor(globalSettings.reverseBlack())
                                    .padding(.horizontal)
                                    .disabled(globalSettings.mainMute)
                                    .onChange(of: globalSettings.soundManager.mainVolume) {
                                        if globalSettings.soundManager.mainVolume != 0 {
                                            globalSettings.mainVolume = globalSettings.soundManager.mainVolume
                                        }
                                    }
                                   
                                
                                Button(action: {
                                    globalSettings.mainMute = !globalSettings.mainMute
                                    
                                    
                                    if globalSettings.mainMute {
                                        // save the volume before mute
                                        globalSettings.mainVolume = globalSettings.soundManager.mainVolume
                                        // mute
                                        globalSettings.soundManager.mainVolume = 0
                                    }
                                    else {
                                        globalSettings.soundManager.mainVolume = globalSettings.mainVolume
                                        
                                    }
                                    
                                    globalSettings.soundManager.updateVolume(for: .main)
                                }) {
                                    Image(globalSettings.darkMode ? "white_sound_off" : "black_sound_off")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                
                                
                            }
                            .padding(.bottom)
                            HStack() {
                                Text("Music")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                    .foregroundColor(globalSettings.reverseBlack())
                                
                                Slider(value: $globalSettings.soundManager.musicVolume, in: 0...1, step: 0.01)
                                    .accentColor(globalSettings.reverseBlack())
                                    .padding(.horizontal)
                                    .disabled(globalSettings.musicMute)
                                    .onChange(of: globalSettings.soundManager.musicVolume) {
                                        if globalSettings.soundManager.musicVolume != 0 {
                                            globalSettings.musicVolume = globalSettings.soundManager.musicVolume
                                        }
                                    }
                                
                                Button(action: {
                                    globalSettings.musicMute = !globalSettings.musicMute
                                    
                                    
                                    if globalSettings.musicMute {
                                        // save the volume before mute
                                        globalSettings.musicVolume = globalSettings.soundManager.musicVolume
                                        // mute
                                        globalSettings.soundManager.musicVolume = 0
                                    }
                                    else {
                                        globalSettings.soundManager.musicVolume = globalSettings.musicVolume
                                        
                                    }
                                    
                                    globalSettings.soundManager.updateVolume(for: .music)
                                    
                                }) {
                                    Image(globalSettings.darkMode ? "white_sound_off" : "black_sound_off")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                
                                
                                
                            }
                            .padding(.bottom)
                            HStack() {
                                Text("Effects")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                    .foregroundColor(globalSettings.reverseBlack())
                                
                                Slider(value: $globalSettings.soundManager.effectsVolume, in: 0...1, step: 0.01)
                                    .accentColor(globalSettings.reverseBlack())
                                    .padding(.horizontal)
                                    .disabled(globalSettings.effectsMute)
                                    .onChange(of: globalSettings.soundManager.effectsVolume) {
                                        if globalSettings.soundManager.effectsVolume != 0 {
                                            globalSettings.effectsVolume = globalSettings.soundManager.effectsVolume
                                        }
                                    }
                                
                                Button(action: {
                                    globalSettings.effectsMute = !globalSettings.effectsMute
                                    
                                    
                                    if globalSettings.effectsMute {
                                        // save the volume before mute
                                        globalSettings.effectsVolume = globalSettings.soundManager.effectsVolume
                                        // mute
                                        globalSettings.soundManager.effectsVolume = 0
                                    }
                                    else {
                                        globalSettings.soundManager.effectsVolume = globalSettings.effectsVolume
                                        
                                    }
                                    
                                    globalSettings.soundManager.updateVolume(for: .effects)
                                }) {
                                    Image(globalSettings.darkMode ? "white_sound_off" : "black_sound_off")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                
                            }
                            
                        }
                        .padding()
                        .background(globalSettings.darkMode ? Color(red: 33/255, green: 33/255, blue: 33/255) : Color.gray.opacity(0.1)) // Light grey background
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding()
                    
                    // Second Game Design Options Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Game Design Options")
                            .font(.headline)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading) 
                            .foregroundColor(globalSettings.reverseBlack())// Align text to the left
                        VStack {
                            HStack() {
                                TextField("Enter X symbol", text: $globalSettings.playerXSymbol)
                                    .textFieldStyle(CustomRoundedBorderTextFieldStyle(
                                        textColor: globalSettings.reverseBlack(),
                                        placeholderColor: .white,
                                        backgroundColor: globalSettings.reverseWhite(),
                                        borderColor: .gray
                                    ))
                                    .disabled(globalSettings.useDefaultX)
                                    .onSubmit() {
                                        globalSettings.validateX()
                                    }// Cursor color

                                
                                Toggle(isOn: $globalSettings.useDefaultX) {
                                    Text("Default?")
                                        .foregroundColor(globalSettings.reverseBlack())
                                        .onChange(of: globalSettings.useDefaultX) {
                                            if globalSettings.useDefaultX {
                                                globalSettings.playerXSymbol = "X"
                                            }
                                            else {
                                                globalSettings.playerXSymbol = ""
                                            }
                                            
                                        }
                                }
                                
                                
                            }
                            HStack() {
                                TextField("Enter O symbol", text: $globalSettings.playerOSymbol)
                                    .textFieldStyle(CustomRoundedBorderTextFieldStyle(
                                        textColor: globalSettings.reverseBlack(),
                                        placeholderColor: .white,
                                        backgroundColor: globalSettings.reverseWhite(),
                                        borderColor: .gray
                                    ))
                                    .disabled(globalSettings.useDefaultO)
                                    .onSubmit() {
                                        globalSettings.validateO()
                                    }
                                
                                Toggle(isOn: $globalSettings.useDefaultO) {
                                    Text("Default?")
                                        .foregroundColor(globalSettings.reverseBlack())
                                        .onChange(of: globalSettings.useDefaultO) {
                                            if globalSettings.useDefaultO {
                                                globalSettings.playerOSymbol = "O"
                                            }
                                            else {
                                                globalSettings.playerOSymbol = ""
                                            }
                                        }
                        
                                }
                                
                                
                            }
                           
                            HStack() {
                                Text("Symbol Size")

                                    .foregroundColor(globalSettings.reverseBlack())
                                
                                Slider(value: $globalSettings.symbolSize, in: 10...60, step: 1)
                                    .accentColor(globalSettings.reverseBlack())
                                    .padding(.horizontal)
                            }
                            HStack() {
                                
                                Toggle(isOn: $globalSettings.connected) {
                                    Text("Connected Grid?")
                                        .foregroundColor(globalSettings.reverseBlack())
                                }
                            }
                        }
                        .padding()
                        .background(globalSettings.darkMode ? Color(red: 33/255, green: 33/255, blue: 33/255) : Color.gray.opacity(0.1)) // Light grey background
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        
                    }
                    .padding()
                    
                    // Third Theme Modes
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Theme")
                            .font(.headline)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(globalSettings.reverseBlack())// Align text to the left
                        VStack {
                            HStack() {
                                
                                Toggle(isOn: $globalSettings.darkMode) {
                                    Text("Dark Mode Toggle")
                                        .foregroundColor(globalSettings.reverseBlack())
                                }

                            }
                            
//                            HStack() {
//                                Text("Color")
//                                    .foregroundColor(globalSettings.reverseBlack())
//                                
//                                Slider(value: $globalSettings.colorShifter, in: 0...255, step: 1)
//                                    .accentColor(globalSettings.reverseBlack())
//                                    .padding(.horizontal)
//                                    .disabled(globalSettings.mainMute)
//                            }
                            
                        }
                        .padding()
                        .background(globalSettings.darkMode ? Color(red: 33/255, green: 33/255, blue: 33/255) : Color.gray.opacity(0.1)) // Light grey background
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        
                    }
                    .padding()
                    
                    
                    Spacer()
                    HStack {
                        Text("Copyright © 2024. All Rights Reserved.")
                            .font(.footnote)
                            .padding()
                            .foregroundColor(Color.gray)
                    }
                    
                }
                .onAppear {
                    
                }
                //                    .onChange(of: volume) {
                //                        // Update the volume in your audio manager
                //                        // AudioManager.shared.setVolume(newVolume)
                //                    }
                
                
                
            }
        }
        .animation(.easeInOut(duration: 0.2), value: globalSettings.darkMode)
        
    }
}



struct CustomRoundedBorderTextFieldStyle: TextFieldStyle {
    var textColor: Color
    var placeholderColor: Color
    var backgroundColor: Color = Color(.systemGray6)
    var borderColor: Color = Color(.systemGray3)

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 5).fill(backgroundColor))
            .foregroundColor(textColor)
            .accentColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1)
                    
            )
    }
}





#Preview {
    SettingsView()
        .environmentObject(GlobalSettings())
}

