//
//  MainMenuView.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/5/24.
//

import Foundation

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("TIC TAC TOE")
                    .font(.system(size: 45, weight: .heavy))
                    .padding(.bottom, 50)
                
                NavigationLink(destination: ContentView(gameMode: .singlePlayer)) {
                    Text("Singleplayer")
                        .frame(width: 200, height: 50)
                        .background(.black)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .clipShape(Capsule())
                }
                .padding(.bottom, 20)
                
                NavigationLink(destination: ContentView(gameMode: .twoPlayer)) {
                    Text("Multiplayer")
                        .frame(width: 200, height: 50)
                        .background(.black)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
    }
}

#Preview {
    MainMenuView()
}
