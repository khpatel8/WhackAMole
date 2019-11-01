//
//  GameViewController.swift
//  WhackAMole
//
//  Created by Kunj Patel on 7/26/19.
//  Copyright © 2019 RSC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import os.log

var sizeOfView: CGSize!
var notWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
var notBlackColor = UIColor(red: 73/255, green: 46/255, blue: 16/255, alpha: 1.0)

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sizeOfView = view!.frame.size
        gameAchievements()
        
        if let view = self.view as! SKView?{
            if let scene = TitleScene(fileNamed: "TitleScene"){
                scene.scaleMode = .aspectFill
                highScore = scores[0].score
                
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Private Functions
    
    private func gameAchievements(){
        if let savedScores = loadScores(){
            scores += savedScores
        }
        else {
            loadSampleScores()
        }
    }
    
    private func loadSampleScores(){
        guard let saved1 = SavedGame(name: "Color Pop", score: 0) else {
            fatalError("Unable to instantiate saved1")
        }
        scores += [saved1]
    }
    
    private func loadScores() -> [SavedGame]?{
        return (NSKeyedUnarchiver.unarchiveObject(withFile: SavedGame.ArchiveURL.path) as? [SavedGame])
    }
}
