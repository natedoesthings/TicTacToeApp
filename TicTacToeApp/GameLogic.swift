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
    
    
    func buttonLabel(i: Int) -> String {
        if let player = board[i] {
            return player == .X ? "X" : "O"
        }
        return ""
    }
    
    func buttonTap(i: Int, gameMode: GameMode, Difficulty: Difficulty) {
        guard board[i] == nil && winner == nil else {
            return
        }
        
        board[i] = activePlayer
//        result[i] = activePlayer == .X ? "X" : "O"
        
        
        SoundManager.shared.playSound(named: "MoveSound")
        
        if let winCombination = getWinCombination() {
            winner = activePlayer
            winningCombination = winCombination
            if activePlayer == .X {
                playerXScore += 1
            } else {
                playerOScore += 1
            }
            
            SoundManager.shared.playSound(named: "WinningSound")
        } else if counter < 8{
            activePlayer = (activePlayer == .X) ? .O : .X
            
            if gameMode == .singlePlayer && activePlayer == .O {
                if Difficulty == .easy {
                    easyBotMove()
                }
                else {
                    modelMove()
                    let move = counter != 0 ? aiMove() : botFirstMove()
                    readBoard(move: move)
                }
               
                
            }
            counter += 1
            
        }
        else {
            // Set winner to Tie
            winner = .T            
            // Play loosing sound
            SoundManager.shared.playSound(named: "LoosingSound")
            
   
        }
        
        
    }

    
    
    func playerScoreColor(playerXScore: Int, playerOScore: Int, colorScheme: ColorScheme) -> Color {
        if playerXScore > playerOScore {
                return .green
        } else if playerXScore < playerOScore {
                return .red
            } else {
                return colorScheme == .dark ? .white : .black
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
    
    func botFirstMove() -> Int {
        
        let move = board[4] != .X ? 4 : 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.buttonTap(i: move, gameMode: .singlePlayer, Difficulty: .hard)
        }
        return move
    }
    
    
    func modelMove(){
        // Load the model
        let model = try! TicTacToeAutomatic(configuration: MLModelConfiguration())
        
        let input = TicTacToeAutomaticInput(state_1: board[0]?.stringValue ?? "", state_2: board[1]?.stringValue ?? "", state_3: board[2]?.stringValue ?? "", state_4: board[3]?.stringValue ?? "", state_5: board[4]?.stringValue ?? "", state_6: board[5]?.stringValue ?? "", state_7: board[6]?.stringValue ?? "", state_8: board[7]?.stringValue ?? "", state_9: board[8]?.stringValue ?? "")
            
        
        // Make prediction
        do {
            let prediction = try model.prediction(input: input)
            let optimalMove = prediction.label
            print("Optimal move is at index: \(optimalMove)")
        } catch {
            print("Prediction failed with error: \(error)")
            print("Input data was: \(input)")

        }
    }
    
    func aiMove() -> Int {
        guard activePlayer == .O else { return -1}
        
        let move = bestMove()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.buttonTap(i: move, gameMode: .singlePlayer, Difficulty: .hard)
        }
        
        return move
    }
    
    
   
    /**
     Minimax Algorithm
     https://www.youtube.com/watch?v=l-hh51ncgDI&ab_channel=SebastianLague
     */
    func minimax(board: [Player?], depth: Int, isMaximizing: Bool) -> Int {
            // Evaluate the board
            if let result = checkWin(board: board) {
                    switch result {
                    case .X:
                        return depth - 10
                    case .O:
                        return 10 - depth
                    case .T:
                        return 0
                    }
                }
            
            // Get all available moves
            let availableMoves = board.enumerated().compactMap { $0.element == nil ? $0.offset : nil }
            
            if isMaximizing {
                var maxEval = Int.min
                for move in availableMoves {
                    var newBoard = board
                    newBoard[move] = .X
                    let eval = minimax(board: newBoard, depth: depth + 1, isMaximizing: false)
                    maxEval = max(maxEval, eval)
                }
                return maxEval
            } else {
                var minEval = Int.max
                for move in availableMoves {
                    var newBoard = board
                    newBoard[move] = .O
                    let eval = minimax(board: newBoard, depth: depth + 1, isMaximizing: true)
                    minEval = min(minEval, eval)
                }
                return minEval
            }
        }
    
    /**
     Returns the player that won the game
     */
    func checkWin(board: [Player?]) -> Player? {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]
        
        for pattern in winPatterns {
            if let player = board[pattern[0]], board[pattern[1]] == player, board[pattern[2]] == player {
                return player
            }
        }
        
        return board.contains(nil) ? nil : .T
    }
    
    /**
     Calculates the most optimal move using the minimax algorithm
     */
    func bestMove() -> Int {
        var bestMove = -1
        var bestValue = Int.min
        for i in 0..<board.count {
            if board[i] == nil {
                var newBoard = board
                newBoard[i] = .O
                let moveValue = minimax(board: newBoard, depth: 2, isMaximizing: true)
                if moveValue > bestValue {
                    bestValue = moveValue
                    bestMove = i
                }
            }
        }
        return bestMove
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
