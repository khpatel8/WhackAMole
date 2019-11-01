//
//  TitleScene.swift
//  WhackAMole
//
//  Created by Kunj Patel on 7/26/19.
//  Copyright © 2019 RSC. All rights reserved.
//

import Foundation
import SpriteKit
import os.log

var highScore: Int = 0

var scores = [SavedGame]()
var COUNTDOWN = 10

var moleSize = CGSize(width: sizeOfView.width/1.85, height: sizeOfView.width/1.85)

class TitleScene: SKScene {
    
    var btnPlay: UIButton!
    var btnReset: UIButton!
    var achievementTitle: UILabel!

    var gameTitle = SKLabelNode()
    var gameFAQ = SKLabelNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = notBlackColor
        setUpText()
    }
    
    @objc func playTheGame() {
        self.view?.presentScene(GameScene(), transition: SKTransition.fade(withDuration: 1.0))
        btnPlay.removeFromSuperview()
        
        btnReset.removeFromSuperview()
        achievementTitle.removeFromSuperview()
        
        gameTitle.removeFromParent()
        gameFAQ.removeFromParent()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    
    @objc func resetTheGame() {
        achievementTitle.text = " "
        scores[0].score = 0
        highScore = 0
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: SavedGame.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("High Score successfully saved", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save high score...", log: OSLog.default, type: .error)
        }
    }
    
    func setUpText() {
        sizeOfView = view!.frame.size
        
        let scaleYPosition = sizeOfView.height
        let btnSize: CGFloat = view!.frame.size.width/5

        gameTitle = SKLabelNode(fontNamed: "Marker Felt")
        gameTitle.fontColor = notWhiteColor
        gameTitle.fontSize = scaleYPosition/15
        gameTitle.position = CGPoint(x: self.frame.midX, y: self.frame.midY + scaleYPosition/4)
        gameTitle.text = "WHACK A MOLE!!!"
        self.addChild(gameTitle)
        
        gameFAQ = SKLabelNode(fontNamed: "Marker Felt")
        gameFAQ.fontColor = notWhiteColor
        gameFAQ.fontSize = scaleYPosition/60
        gameFAQ.position = CGPoint(x: self.frame.midX, y: self.frame.midY + scaleYPosition/4.5)
        gameFAQ.text = "--Tap the mole, not the emplty hole--"
        self.addChild(gameFAQ)
        
        //PLAY BUTTON with image
        btnPlay = UIButton(frame: CGRect(x: 0, y: 0, width: btnSize, height: btnSize/2))
        btnPlay.backgroundColor = notBlackColor
        btnPlay.center = CGPoint(x: sizeOfView.width/2, y: sizeOfView.height/1.25 )
        btnPlay.setImage(UIImage(named: "playWhackAMole"), for: UIControl.State.normal)
        
        btnPlay.addTarget(self, action: (#selector(TitleScene.playTheGame)), for: UIControl.Event.touchUpInside)
        self.view?.addSubview(btnPlay)
        
        spawnMole()
        
        //HIGH SCORE
        achievementTitle = UILabel(frame: CGRect(x: self.frame.midX + 20, y: (scaleYPosition/1.18), width: sizeOfView.width - btnSize, height: 100))
        achievementTitle.textColor = notWhiteColor
        achievementTitle.font = UIFont(name: "Marker Felt", size: scaleYPosition/20)
        achievementTitle.textAlignment = NSTextAlignment.center
        achievementTitle.text = "High Score: \(highScore)"
        
        self.view?.addSubview(achievementTitle)
        
        //RESET HIGH SCORE
        btnReset = UIButton(frame: CGRect(x: 0, y: 0, width: btnSize/1.5, height: btnSize/1.5))
        btnReset.backgroundColor = notBlackColor
        btnReset.center = CGPoint(x: achievementTitle.frame.maxX, y: achievementTitle.frame.midY)
        btnReset.setImage(UIImage(named: "resetWhackAMoleButton"), for: UIControl.State.normal)
        
        btnReset.addTarget(self, action: (#selector(TitleScene.resetTheGame)), for: UIControl.Event.touchUpInside)
        
        self.view?.addSubview(btnReset)
        
    }
    
    func spawnMole() {
        mole = SKSpriteNode(imageNamed: "moleHole")
        mole?.size = moleSize
        mole?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mole?.zPosition = 1
        self.addChild(mole!)
    }
}
