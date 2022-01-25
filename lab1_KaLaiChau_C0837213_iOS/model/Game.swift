//
//  Game.swift
//  lab1_KaLaiChau_C0837213_iOS
//
//  Created by Philip Chau on 18/1/2022.
//

import Foundation

class Game {
    
    var oScore:Int = 0
    var xScore:Int = 0
    var turn:Int = 0
    var currentPlayer:Int = 0
    var gameState:Bool = true
    
    init (oScore:Int, xScore:Int, turn:Int, currentPlayer:Int, gameState:Bool){
        self.oScore = oScore
        self.xScore = xScore
        self.turn = turn
        self.currentPlayer = currentPlayer
        self.gameState = gameState
    }
    
    private let winningPattern:[[Int]] = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [2,4,6]
    ]

    func winner (boardState:[Int], turn:Int)->String {
        var result:String = ""
        for pattern in winningPattern {
            if (boardState[pattern[0]] != 3 &&
                boardState[pattern[0]] == boardState[pattern[1]] &&
                boardState[pattern[1]] == boardState[pattern[2]]){
                result = "true"
                break
            }else{
                result = "false"
            }
        }

        if turn == 9 && result == "false"{
            result = "draw"
        }

        return result
    }

}
