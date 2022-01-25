//
//  ViewController.swift
//  lab1_KaLaiChau_C0837213_iOS
//
//  Created by Philip Chau on 18/1/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    var boardState:[Int] = []
    let game = Game(oScore: 0, xScore: 0, turn: 0, currentPlayer: 0, gameState: true)
    lazy var buttons:[UIButton] = [btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8]
    var lastPosition: Int? = nil
    var gameRecord = [GameRecord]()
    
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
            3,3,3,
            3,3,3,
            3,3,3
        ]
        
        //create gesture recognizer
        let directions:[UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
        
        fetchData()
        print(gameRecord)
    }
    
    
    @IBAction func handleBtnOnClick(_ sender: UIButton) {
        
        //change number of turn
        game.turn += 1

        //record current board state
        self.boardState[sender.tag] = game.currentPlayer
        self.lastPosition = sender.tag
        
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            reverseLastStep()
        }
    }
    
    private func reverseLastStep () {
        //change number of turn
        game.turn -= 1

        //record current board state
        self.boardState[lastPosition!] = 3

        //reove the image of certain button
        buttons[lastPosition!].setImage(UIImage(named: ""), for: .normal)
        
        //change back current player, either 0 or 1
        if game.currentPlayer == 0 {
            game.currentPlayer = 1
        }else{
            game.currentPlayer = 0
        }
        
        //enable certain button
        buttons[lastPosition!].isEnabled = true
    }
    
    private func reset () {
        //reset turn
        game.turn = 0
        
        //reset game state
        game.gameState = true

        //initialize board state
        self.boardState = [
            3,3,3,
            3,3,3,
            3,3,3
        ]
        
        //enable all button
        for btn in buttons {
            btn.isEnabled = true
            btn.setImage(nil, for: .normal)
        }
        
        //remove alert
        self.alertText.text = ""
    }
    
    @IBAction func handleLoadBtn(_ sender: Any) {
        fetchData()
        boardState = self.gameRecord[0].boardState!
        print(boardState)
        game.oScore = Int(self.gameRecord[0].oScore)
        game.xScore = Int(self.gameRecord[0].xScore)
        oScoreLabel.text = "\(game.oScore)"
        xScoreLabel.text = "\(game.xScore)"
        game.currentPlayer = Int(self.gameRecord[0].currentPlayer)
        for (i,state) in boardState.enumerated() {
            if state == 0{
                print("this is circle")
                buttons[i].setImage(UIImage(named: "circle"), for: .normal)
                buttons[i].isEnabled = false
            }else if state == 1{
                print("this is cross")
                buttons[i].setImage(UIImage(named: "cross"), for: .normal)
                buttons[i].isEnabled = false
            }else if state == 3{
                print("this is nil")
                buttons[i].setImage(nil, for: .normal)
                buttons[i].isEnabled = true
            }
        }
        alertText.text = ""
    }
    @IBAction func handleSaveBtn(_ sender: Any) {
        if self.gameRecord.count == 0 {
            let defaultRow = GameRecord(context: context)
            defaultRow.boardState = boardState
            defaultRow.xScore = 0
            defaultRow.oScore = 0
            gameRecord.append(defaultRow)
            saveData()
            fetchData()
        }
        self.gameRecord[0].boardState = boardState
        self.gameRecord[0].oScore = Int16(game.oScore)
        self.gameRecord[0].xScore = Int16(game.xScore)
        self.gameRecord[0].currentPlayer = Int16(game.currentPlayer)
        saveData()
    }
    
    private func fetchData () {
        let request:NSFetchRequest<GameRecord> = GameRecord.fetchRequest()
        request.fetchLimit = 1
        do {
            self.gameRecord = try context.fetch(request)
        } catch {
            print("Error load items ... \(error.localizedDescription)")
        }
    }
    
    private func saveData () {
        do {
            try context.save()
        }
        catch {
            print("Error saving folders .. \(error.localizedDescription)")
        }
    }
}

