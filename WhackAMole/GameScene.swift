//
//  GameScene.swift
//  WhackAMole
//
//  Created by Kunj Patel on 7/26/19.
//  Copyright © 2019 RSC. All rights reserved.
//

import SpriteKit
import GameplayKit
import os.log

var mole: SKSpriteNode?
var hole1: SKSpriteNode?
var hole2: SKSpriteNode?
var hole3: SKSpriteNode?
var hole4: SKSpriteNode?

var holeSize = CGSize(width: sizeOfView.width/3, height: sizeOfView.width/3)
var holePositionOffset = holeSize.height / 2.0 + 20.0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var statusLabel: SKLabelNode?
    var scoreLabel: SKLabelNode?
    var timerLabel: SKLabelNode?
    
    var score = 0
    var isAlive = true
    
    var prevRandValue = 0
    
    var upperLeft = CGPoint()
    var upperRight = CGPoint()
    var lowerLeft = CGPoint()
    var lowerRight = CGPoint()
    var positionChoices = [CGPoint]()
    
    var touchLocation: CGPoint?
    var touchNode: SKNode?
    
    var countDownMoleVar = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = notBlackColor
        physicsWorld.contactDelegate = self

        resetGameVariables()
        spawnStatusLabel()
        spawnScoreLabel()
        spawnTimerLabel()
        countDownMoleTimer()
    }
    
    func resetGameVariables(){
        score = 0
        isAlive = true
        countDownMoleVar = COUNTDOWN
        positionChoices = [upperLeft, upperRight, lowerLeft, lowerRight]
        spawnHole1()
        spawnHole2()
        spawnHole3()
        spawnHole4()
        loadPositionArray()
    }
    
    func countDownMoleTimer() {
            let wait = SKAction.wait(forDuration: 0.60)
            let runCountDown = SKAction.run {
                
            if self.isAlive {
                self.statusLabel?.text = "Catch me if you can!"
                self.statusLabel?.fontColor = notWhiteColor
                self.spawnMoleRandomly()
                self.countDownMoleVar = self.countDownMoleVar - 1
                self.updateTimer()
                
                if self.countDownMoleVar <= 0 {
                    self.gameOver()
                    }
                }
            }
            let sequence = SKAction.sequence([wait, runCountDown])
            let moleTimerRepeat = SKAction.repeat(sequence, count: COUNTDOWN)
            self.run(moleTimerRepeat)
    }
    
    func spawnMoleRandomly(){
        var randomPosition = Int.random(in: 0 ... 3)
        mole?.removeFromParent()
        
        while randomPosition == prevRandValue {
            randomPosition = Int.random(in: 0 ... 3)
        }
        
        self.prevRandValue = randomPosition
        mole = SKSpriteNode(imageNamed: "moleHole")
        mole?.size = holeSize
        mole?.name = "mole"
        mole?.position =  positionChoices[randomPosition]
        mole?.zPosition = 1
        self.addChild(mole!)
        
        let wait = SKAction.wait(forDuration: 0.2)
        self.run(wait)
    }
    
    
    func spawnHole1() {
        hole1 = SKSpriteNode(imageNamed: "dirtyHole")
        hole1?.size = holeSize
        hole1?.name = "1"
        hole1?.position = CGPoint(x: self.frame.midX - holePositionOffset, y: self.frame.midY + holePositionOffset)
        self.addChild(hole1!)
    }
    
    func spawnHole2() {
        hole2 = SKSpriteNode(imageNamed: "dirtyHole")
        hole2?.size = holeSize
        hole2?.name = "2"
        hole2?.position = CGPoint(x: self.frame.midX + holePositionOffset, y: self.frame.midY + holePositionOffset)
        self.addChild(hole2!)
    }
    
    func spawnHole3(){
        hole3 = SKSpriteNode(imageNamed: "dirtyHole")
        hole3?.size = holeSize
        hole3?.name = "3"
        hole3?.position = CGPoint(x: self.frame.midX - holePositionOffset, y: self.frame.midY - holePositionOffset)
        self.addChild(hole3!)
    }
    
    func spawnHole4(){
        hole4 = SKSpriteNode(imageNamed: "dirtyHole")
        hole4?.size = holeSize
        hole4?.position = CGPoint(x: self.frame.midX + holePositionOffset, y: self.frame.midY - holePositionOffset)
        hole4?.name = "4"
        self.addChild(hole4!)
    }
    
    func spawnStatusLabel(){
        statusLabel = SKLabelNode(fontNamed: "Marker Felt")
        statusLabel?.fontColor = notWhiteColor
        statusLabel?.fontSize = 50
        statusLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 300.0)
        statusLabel?.text = "Start!"
        self.addChild(statusLabel!)
    }
    
    func spawnScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: "Marker Felt")
        scoreLabel?.fontColor = notWhiteColor
        scoreLabel?.fontSize = 40
        scoreLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 185)
        scoreLabel?.text = "Score: \(score)"
        self.addChild(scoreLabel!)
    }
    
    func spawnTimerLabel(){
        timerLabel = SKLabelNode(fontNamed: "Marker Felt")
        timerLabel?.fontColor = notWhiteColor
        timerLabel?.fontSize = 70
        timerLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 255)
        timerLabel?.text = "\(countDownMoleVar)"
        self.addChild(timerLabel!)
    }
    
    func loadPositionArray(){
        positionChoices[0] = CGPoint(x: self.frame.midX - holePositionOffset, y: self.frame.midY + holePositionOffset)
        positionChoices[1] = CGPoint(x: self.frame.midX + holePositionOffset, y: self.frame.midY + holePositionOffset)
        positionChoices[2] = CGPoint(x: self.frame.midX - holePositionOffset, y: self.frame.midY - holePositionOffset)
        positionChoices[3] = CGPoint(x: self.frame.midX + holePositionOffset, y: self.frame.midY - holePositionOffset)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            touchLocation = touch.location(in: self)
            touchNode = atPoint(touchLocation!)

            if touchNode?.name != "mole"{
                isAlive = false
                self.gameOver()
            }
            if touchNode?.name == "mole" {
                score = score + 1
                updateScore()
            }
        }
    }
    
    func gameOver() {
        
        if isAlive == false {
            statusLabel?.text = "Game Reset"
            if score == 0 {
                statusLabel?.fontColor = UIColor.red
                statusLabel?.text = "Skunked!"
                timerLabel?.text = "Game Over!"
                self.waitThenMoveToTitleScreen()
            }
            if score > highScore {
                highScore = score
                statusLabel?.fontColor = UIColor.yellow
                statusLabel?.text = "High Score! \(highScore)"
                saveScores()
            }
        }
        
        
        statusLabel?.fontColor = notWhiteColor
        statusLabel?.text = "Good Score!"
        timerLabel?.text = "Try Again"
        
        hole1?.removeFromParent()
        hole2?.removeFromParent()
        hole3?.removeFromParent()
        hole4?.removeFromParent()
        mole?.removeFromParent()
        
        if score > highScore {
            highScore = score
            statusLabel?.fontColor = UIColor.yellow
            statusLabel?.text = "High Score! \(highScore)"
            saveScores()
        }
        
        if(isAlive == true && score > COUNTDOWN/2) {
            countDownMoleVar = COUNTDOWN
            statusLabel?.text = "Awesome!"
            timerLabel?.text = "Timer Increased!"
            spawnBonusFireworks()
            self.countDownMoleTimer()
        }
        else {
            self.resetTheGame()
        }
    }
    
    func spawnBonusFireworks(){
        var explosion: SKEmitterNode!
        
        explosion = SKEmitterNode(fileNamed: "FireWorksParticle.sks")!
        explosion?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        explosion.zPosition = -1
        explosion.targetNode = self
        self.addChild(explosion!)
        
        let explosionTimerRemove = SKAction.wait(forDuration: 1.0)
        
        let removeExplosiion = SKAction.run {
            explosion?.removeFromParent()
            self.resetTheGame()
        }
        
        self.run(SKAction.sequence([explosionTimerRemove, removeExplosiion]))
    }
    
    func resetTheGame(){
        let wait = SKAction.wait(forDuration: 2.0)
        let gameScene = GameScene(size: self.size)
        let transitionScene = SKTransition.doorway(withDuration: 0.5)
        
        let changeScene = SKAction.run {
            gameScene.scaleMode = SKSceneScaleMode.aspectFill
            self.scene?.view?.presentScene(gameScene, transition: transitionScene)
        }
        
        let sequence = SKAction.sequence([wait, changeScene])
        self.run(SKAction.repeat(sequence, count: 1))
    }
    
    @objc func waitThenMoveToTitleScreen(){
        let wait = SKAction.wait(forDuration: 1.0)
        let transition = SKAction.run {
            if let scene = TitleScene(fileNamed: "TitleScene"){
                let skView = self.view! as SKView
                
                scene.scaleMode = .aspectFill
                
                skView.presentScene(scene)
            }
        }
        let sequence = SKAction.sequence([wait, transition])
        self.run(SKAction.repeat(sequence, count: 1))
    }
    
    func updateScore(){
        scoreLabel?.text = "Score: \(score)"
    }
    
    func updateTimer(){
        timerLabel?.text = "\(countDownMoleVar)"
    }
    
    private func saveScores(){
        scores[0].score = highScore
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: SavedGame.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("High score successfully saved", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save high score", log: OSLog.default, type: .error)
        }
    }
}
