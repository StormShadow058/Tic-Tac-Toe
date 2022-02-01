//
//  MainViewModel.swift
//  Tic Tac Toe
//
//  Created by Vansh Maheshwari on 01/02/22.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @Published var moves: [Play?] = Array(repeating: nil, count: 9)
    @Published var gameDisabled = false
    @Published var alertItem: AlertItem?
    
    func playerMoveProcessing(for position: Int) {
        if isOccupied(in: moves, forindex: position){
            return
        }
        moves[position] = Play(player: .human, borardIndex: position)
        
        if winCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWins
            return
        }
        
        if drawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        gameDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let compPosition = computerPositionDetermination(in: moves)
            moves[compPosition] = Play(player: .comp, borardIndex: compPosition)
            gameDisabled = false
            
            if winCondition(for: .comp, in: moves) {
                alertItem = AlertContext.compWins
                return
            }
            
            if drawCondition(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isOccupied(in moves: [Play?], forindex index: Int) -> Bool {
        return moves.contains(where: { $0?.borardIndex == index})
    }
    
    func computerPositionDetermination(in moves: [Play?]) -> Int {
        
//        If AI can win, it wins
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let compMoves = moves.compactMap { $0 }.filter { $0.player == .comp }
        let compPosition = Set(compMoves.map { $0.borardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(compPosition)
            
            if winPositions.count == 1 {
                let isAvailable = !isOccupied(in: moves, forindex: winPositions.first!)
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        
//        If AI can't win, it blocks
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMoves.map { $0.borardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            if winPositions.count == 1 {
                let isAvailable = !isOccupied(in: moves, forindex: winPositions.first!)
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
//        If AI can't block, it takes middle square
        let center = 4
        if !isOccupied(in: moves, forindex: center) {
            return center
        }
        
        
//        If AI can't take middle sqaure, it takes random square
        var position = Int.random(in: 0..<9)
        
        while isOccupied(in: moves, forindex: position) {
            position = Int.random(in: 0..<9)
        }
        
        return position
    }
    
    func winCondition(for player: Player, in moves: [Play?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPosition = Set(playerMoves.map { $0.borardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) {
            return true
        }
        
        return false
    }
    
    func drawCondition(in moves: [Play?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }

    
}
