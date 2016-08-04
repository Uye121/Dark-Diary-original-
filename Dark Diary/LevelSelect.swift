//
//  MainMenu.swift
//  Dark Diary
//
//  Created by Ulric Ye on 8/1/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import SpriteKit

class LevelSelect: SKScene {
    var level1Selector: MSButtonNode!
    var level2Selector: MSButtonNode!
    var level3Selector: MSButtonNode!
    var level4Selector: MSButtonNode!
    var returnButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Connect the buttons */
        level1Selector = childNodeWithName("level1Selector") as! MSButtonNode
        level2Selector = childNodeWithName("level2Selector") as! MSButtonNode
        level3Selector = childNodeWithName("level3Selector") as! MSButtonNode
        //        level4Selector = childNodeWithName("level4Selector") as! MSButtonNode
        returnButton = childNodeWithName("returnButton") as! MSButtonNode
        
        /* Load the specified levels */
        level1Selector.selectedHandler = {
            if GameManager.sharedInstance.unlockedLevel[GameManager.sharedInstance.currentlevel] == true {
                let skView = self.view as SKView!
                
                GameManager.sharedInstance.currentlevel = 1
                
                let scene = GameScene(fileNamed: "GameScene")! as GameScene
                
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            } else {
                print("Locked")
            }
        }
        
        level2Selector.selectedHandler = {
            if GameManager.sharedInstance.unlockedLevel[GameManager.sharedInstance.currentlevel] == true {
                let skView = self.view as SKView!
                
                GameManager.sharedInstance.currentlevel = 2
                
                let scene = GameScene(fileNamed: "GameScene")! as GameScene
                
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            } else {
                print("Locked")
            }
        }
        
        level3Selector.selectedHandler = {
            if GameManager.sharedInstance.unlockedLevel[GameManager.sharedInstance.currentlevel] == true {
                let skView = self.view as SKView!
                
                GameManager.sharedInstance.currentlevel = 3
                
                let scene = GameScene(fileNamed: "GameScene")! as GameScene
                
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            } else {
                print("Locked")
            }
        }
        
        //        level4Selector.selectedHandler = {
        //            let skView = self.view as SKView!
        //
        //            GameManager.sharedInstance.currentlevel = 4
        //
        //            let scene = GameScene(fileNamed: "GameScene")! as GameScene
        //
        //            scene.scaleMode = .AspectFit
        //
        //            skView.presentScene(scene)
        //        }
        
        returnButton.selectedHandler = {
            let skView = self.view as SKView!
            
            let scene = MainMenu(fileNamed: "MainMenu")! as MainMenu
            
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
    }
}
