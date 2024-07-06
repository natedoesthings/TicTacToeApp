import Foundation

enum Player {
    case X
    case O
}

class TicTacModel: ObservableObject {
    @Published var board: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player? = nil
    @Published var playerXScore: Int = 0
    @Published var playerOScore: Int = 0
    @Published var winningCombination: [Int] = []
    
    func buttonTap(i: Int, gameMode: GameMode) {
        guard board[i] == nil && winner == nil else {
            return
        }
        
        board[i] = activePlayer
                
        if let winCombination = checkWinner() {
            winner = activePlayer
            winningCombination = winCombination
            if activePlayer == .X {
                playerXScore += 1
            } else {
                playerOScore += 1
            }
            print("\(activePlayer) has won the game!")
        } else {
            activePlayer = (activePlayer == .X) ? .O : .X
            if gameMode == .singlePlayer && activePlayer == .O {
                botMove()
            }
        }
    }
    
    func buttonLabel(i: Int) -> String {
        if let player = board[i] {
            return player == .X ? "X" : "O"
        }
        return ""
    }
    
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
        winningCombination = []
    }
    
    func checkWinner() -> [Int]? {
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
    
    func botMove() {
        var availableMoves = [Int]()
        for i in 0..<board.count {
            if board[i] == nil {
                availableMoves.append(i)
            }
        }
        
        if let move = availableMoves.randomElement() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttonTap(i: move, gameMode: .singlePlayer)
            }
        }
    }
}
