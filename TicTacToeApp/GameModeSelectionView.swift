//
//  GameModeSelectionView.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/7/24.
//

import Foundation
import SwiftUI


struct GameModeSelection: View {
    @State private var animateButton = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalSettings: GlobalSettings
    @State private var showRestartButtonEz: Bool = false
    @State private var showRestartButtonMed: Bool = false
    @State private var showRestartButtonHard: Bool = false

    

    
    
    var body: some View {
        NavigationView {
            ZStack {
                globalSettings.reverseWhite().ignoresSafeArea()
                VStack {
                    NavigationLink(destination: ContentView(gameMode: .singlePlayer, Difficulty: .easy, showRestartButton: $showRestartButtonEz).navigationBarBackButtonHidden(true)) {
                        Text("EASY AI?!")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(globalSettings.reverseBlack())
                            .foregroundColor(globalSettings.reverseWhite())
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: ContentView(gameMode: .singlePlayer, Difficulty: .medium,showRestartButton: $showRestartButtonMed).navigationBarBackButtonHidden(true)) {
                        Text("MEDIUM AI?!")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(globalSettings.reverseBlack())
                            .foregroundColor(globalSettings.reverseWhite())
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: ContentView(gameMode: .singlePlayer, Difficulty: .hard,showRestartButton: $showRestartButtonHard).navigationBarBackButtonHidden(true)) {
                        Text("HARDCORE AI?!")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(globalSettings.reverseBlack())
                            .foregroundColor(globalSettings.reverseWhite())
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                    
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        animateButton = true
                    }
                    SoundManager.shared.playSound(named: "NextPage", volumeType: .effects)
                }
                
            }
        }
        
        
    }
}

//#Preview {
//    GameModeSelection()
//        .environmentObject(GlobalSettings())
//}

