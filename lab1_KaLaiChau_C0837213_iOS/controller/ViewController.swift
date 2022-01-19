//
//  ViewController.swift
//  lab1_KaLaiChau_C0837213_iOS
//
//  Created by Philip Chau on 18/1/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var xScoreLabel: UILabel!
    @IBOutlet weak var oScoreLabel: UILabel!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var alertText: UILabel!
    
    var boardState:[Int?] = []
    let game = Game(oScore: 0, xScore: 0, turn: 0, currentPlayer: 0, gameState: true)
    lazy var buttons:[UIButton] = [btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add tag in each button
        var tag = 0
        for btn in buttons {
            btn.tag = tag
            tag += 1
        }
        
        //set initial state of board
        boardState = [
            nil,nil,nil,
            nil,nil,nil,
            nil,nil,nil
        ]
        
        //create gesture recognizer
        let directions:[UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    
    @IBAction func handleBtnOnClick(_ sender: UIButton) {
        
        //change number of turn
        game.turn += 1

        //record current board state
        self.boardState[sender.tag] = game.currentPlayer
        
        //determine winner
        let result = game.winner(boardState: boardState, turn: game.turn)

        if result == "true" {
            if game.currentPlayer == 0 {
                game.oScore += 1
                oScoreLabel.text = "\(game.oScore)"
            }else{
                game.xScore += 1
                xScoreLabel.text = "\(game.xScore)"
            }
            for btn in buttons {
                btn.isEnabled = false
            }
            game.gameState = false
        }else if result == "draw"{
            game.gameState = false
        }else if result == "false" && game.turn == 9{
            game.gameState = false
        }
        
        if game.gameState == false {
            alertText.text = "Please swipe to reset the game"
        }

        //change current player, either 0 or 1
        if game.currentPlayer == 0 {
            sender.setImage(UIImage(named: "circle"), for: .normal)
            game.currentPlayer = 1
        }else{
            sender.setImage(UIImage(named: "cross"), for: .normal)
            game.currentPlayer = 0
        }
        
        //disable clicked button
        sender.isEnabled = false
    }
    
    @objc private func handleGesture (g:UISwipeGestureRecognizer) {
        let gesture = g as UISwipeGestureRecognizer
        switch gesture.direction{
            case .left:
                self.reset()
            case .right:
                self.reset()
            case .up:
                self.reset()
            case .down:
                self.reset()
            default:
                break
        }
    }
    
    private func reset () {
        //reset turn
        game.turn = 0
        
        //reset game state
        game.gameState = true

        //initialize board state
        self.boardState = [
            nil,nil,nil,
            nil,nil,nil,
            nil,nil,nil
        ]
        
        //enable all button
        for btn in buttons {
            btn.isEnabled = true
            btn.setImage(nil, for: .normal)
        }
        
        //remove alert
        self.alertText.text = ""
    }
}

