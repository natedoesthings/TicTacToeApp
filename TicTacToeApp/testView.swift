//
//  testView.swift
//  TicTacToeApp
//
//  Created by Nathanael Tesfaye on 7/10/24.
//

import Foundation
import SwiftUI

struct testView: View {
    var gameMode: GameMode
    var Difficulty: Difficulty
    @ObservedObject var TicTac = TicTacModel()
    
//    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalSettings: GlobalSettings
    
    var body: some View {
        let col = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

        LazyVGrid(columns: col, spacing: 0) {
            ForEach(0..<9) { i in
                Button(action: {
                    TicTac.buttonTap(i: i, gameMode: gameMode, Difficulty: Difficulty)
                }, label: {
                    Text(TicTac.buttonLabel(i:i, playerX:globalSettings.playerXSymbol, playerO:globalSettings.playerOSymbol))
                        .frame(width: 120, height: 120)
                        .background(tieBreaker(i:i))
                        .foregroundColor(globalSettings.reverseBlack())
                        .font(.system(size: 45, weight: .heavy))
                        .overlay(
                            Rectangle()
                                .stroke(globalSettings.reverseBlack(), lineWidth: 6)
                        )
                }).buttonStyle(NoEffectButtonStyle())
            }
        }
        .padding(.vertical)
    }
    
    private func tieBreaker(i: Int) -> Color {
        if TicTac.winner != .T {
            return TicTac.winningCombination.contains(i) ? .green : globalSettings.reverseWhite()
        }
        else {
            return .red
        }
    }
}



struct TicTacToeCellShape: Shape {
    var index: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Define the lines to be drawn based on the index
        switch index {
        case 0: // Top-left
            break
        case 1: // Top-center
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
        case 2: // Top-right
//            path.move(to: CGPoint(x: 0, y: 0))
//            path.addLine(to: CGPoint(x: 0, y: height))
//            path.move(to: CGPoint(x: 0, y: height))
//            path.addLine(to: CGPoint(x: width, y: height))
            break
        case 3: // Middle-left
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
        case 4: // Middle-center (full rectangle)
            path.addRect(rect)
        case 5: // Middle-right
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
        case 6: // Bottom-left
//            path.move(to: CGPoint(x: width, y: 0))
//            path.addLine(to: CGPoint(x: width, y: height))
            break
        case 7: // Bottom-center
            path.move(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
            
        case 8: // Bottom-right
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
        default:
            break
        }
        
//        path.stroke(style: .init(lineWidth: 4))

        return path
    }
}

#Preview {
    testView(gameMode: .singlePlayer, Difficulty: .medium)
        .environmentObject(GlobalSettings())
}
