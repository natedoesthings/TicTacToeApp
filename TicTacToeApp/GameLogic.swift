import Foundation
import SwiftUI
import CoreML

enum Player {
    case X
    case O
    case T
    
    var stringValue: String {
            switch self {
            case .X:
                return "X"
            case .O:
                return "O"
            case .T:
                return "T"
            }
        }
}

class TicTacModel: ObservableObject {
    @Published var board: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player? = nil
    @Published var playerXScore: Int = 0
    @Published var playerOScore: Int = 0
    @Published var winningCombination: [Int] = []
    @Published var counter: Int = 0
    
    
    func buttonLabel(i: Int, playerX: String, playerO: String) -> String {
        if let player = board[i] {
            return player == .X ? playerX : playerO
        }
        return ""
    }
    
    func buttonTap(i: Int, gameMode: GameMode, Difficulty: Difficulty) {
        guard board[i] == nil && winner == nil else {
            return
        }
        
        board[i] = activePlayer
//        result[i] = activePlayer == .X ? "X" : "O"
        
        
        SoundManager.shared.playSound(named: "MoveSound", volumeType: .effects)
        
        if let winCombination = getWinCombination() {
            winner = activePlayer
            winningCombination = winCombination
            if activePlayer == .X {
                playerXScore += 1
            } else {
                playerOScore += 1
            }
            
            SoundManager.shared.playSound(named: "WinningSound", volumeType: .effects)
        } else if counter < 8{
            activePlayer = (activePlayer == .X) ? .O : .X
            
            if gameMode == .singlePlayer && activePlayer == .O {
                if Difficulty == .easy {
                    easyBotMove()
                }
                else if Difficulty == .medium {
                    mediumBotMove()
//                    let move = counter != 0 ? aiMove() : botFirstMove()
//                    readBoard(move: move)
                }
                else {
                    hardBotMove()
                }
               
                
            }
            counter += 1
            
        }
        else {
            // Set winner to Tie
            winner = .T            
            // Play loosing sound
            SoundManager.shared.playSound(named: "LoosingSound", volumeType: .effects)
            
   
        }
        
        
    }

    
    
    func playerScoreColor(playerXScore: Int, playerOScore: Int, darkmode: Bool) -> Color {
        if playerXScore > playerOScore {
                return .green
        } else if playerXScore < playerOScore {
                return .red
            } else {
                return darkmode ? .white : .black
            }
        }
    
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
        counter = 0
        winningCombination = []
    }
    
    func getWinCombination() -> [Int]? {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]
        
        for pattern in winPatterns {
            if board[pattern[0]] == activePlayer && board[pattern[1]] == activePlayer && board[pattern[2]] == activePlayer {
                return pattern
            }
        }
        
        return nil
    }
    
    func easyBotMove() {
        var availableMoves = [Int]()
        for i in 0..<board.count {
            if board[i] == nil {
                availableMoves.append(i)
            }
        }
        
        if let move = availableMoves.randomElement() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttonTap(i: move, gameMode: .singlePlayer, Difficulty: .easy)
            }
        }
    }
    
    
    func mediumBotMove(){
        // Load the model
        let model = try! TicTacToeAI_MedBot(configuration: MLModelConfiguration())
        
        let input = TicTacToeAI_MedBotInput(state_1: board[0]?.stringValue ?? "", state_2: board[1]?.stringValue ?? "", state_3: board[2]?.stringValue ?? "", state_4: board[3]?.stringValue ?? "", state_5: board[4]?.stringValue ?? "", state_6: board[5]?.stringValue ?? "", state_7: board[6]?.stringValue ?? "", state_8: board[7]?.stringValue ?? "", state_9: board[8]?.stringValue ?? "")
            
        
        // Make prediction
        do {
            let prediction = try model.prediction(input: input)
            let optimalMove = prediction.label
            print("Optimal move is at index: \(optimalMove)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttonTap(i: Int(optimalMove), gameMode: .singlePlayer, Difficulty: .medium)
            }
        } catch {
            print("Prediction failed with error: \(error)")
            print("Input data was: \(input)")
            easyBotMove()

        }
    }
    
    func hardBotMove() {
        // Load the model
        let model = try! TicTacToeAI_HardBot(configuration: MLModelConfiguration())
        
        let input = TicTacToeAI_HardBotInput(state_1: board[0]?.stringValue ?? "", state_2: board[1]?.stringValue ?? "", state_3: board[2]?.stringValue ?? "", state_4: board[3]?.stringValue ?? "", state_5: board[4]?.stringValue ?? "", state_6: board[5]?.stringValue ?? "", state_7: board[6]?.stringValue ?? "", state_8: board[7]?.stringValue ?? "", state_9: board[8]?.stringValue ?? "")
            
        
        // Make prediction
        do {
            let prediction = try model.prediction(input: input)
            let optimalMove = prediction.label
            print("Optimal move is at index: \(optimalMove)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttonTap(i: Int(optimalMove), gameMode: .singlePlayer, Difficulty: .hard)
            }
        } catch {
            print("Prediction failed with error: \(error)")
            print("Input data was: \(input)")
            easyBotMove()

        }
    }
    
    
    /**
     Reads the board
     */
    func readBoard(move: Int) {
        var temp = ""
        
        for player in board {
            if let value = player?.stringValue {
                temp += value
            } else {
                temp += ""
            }
            
            temp += ","
        }
        
        temp += "\(move)"
        
        print(temp)
    }
    
   
 
}



