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
    var levelSelectorCamera: SKCameraNode?
    var levelWall: SKSpriteNode!
    var touchNode: SKSpriteNode!
    var locked: SKLabelNode!
    var levelWallHeight: CGFloat!
    var levelWallWidth: CGFloat!
    
    override func didMoveToView(view: SKView) {
        /* Connect the buttons */
        level1Selector = childNodeWithName("level1Selector") as! MSButtonNode
        level2Selector = childNodeWithName("level2Selector") as! MSButtonNode
        level3Selector = childNodeWithName("level3Selector") as! MSButtonNode
        //        level4Selector = childNodeWithName("level4Selector") as! MSButtonNode
        returnButton = childNodeWithName("//returnButton") as! MSButtonNode
        levelSelectorCamera = childNodeWithName("//camera") as? SKCameraNode
        levelWall = childNodeWithName("levelWall") as! SKSpriteNode
        touchNode = childNodeWithName("touchNode") as! SKSpriteNode
        locked = childNodeWithName("//locked") as! SKLabelNode
        
        locked.hidden = true
        
        /* Load the specified levels */
        level1Selector.selectedHandler = {
            GameManager.sharedInstance.currentlevel = 1

            if GameManager.sharedInstance.unlockedLevel[GameManager.sharedInstance.currentlevel] == true {
                let skView = self.view as SKView!
                
                let scene = GameScene(fileNamed: "GameScene")! as GameScene
                
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            } else {
                self.locked.hidden = false
                self.locked.runAction(SKAction.fadeInWithDuration(0.5), completion:{
                    self.locked.runAction(SKAction.fadeOutWithDuration(0.5))
                })
            }
        }
        
        level2Selector.selectedHandler = {
            GameManager.sharedInstance.currentlevel = 2

            if GameManager.sharedInstance.unlockedLevel[GameManager.sharedInstance.currentlevel] == true {
                let skView = self.view as SKView!
                
                let scene = GameScene(fileNamed: "GameScene")! as GameScene
                
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            } else {
                self.locked.hidden = false
                self.locked.runAction(SKAction.fadeInWithDuration(0.5), completion:{
                    self.locked.runAction(SKAction.fadeOutWithDuration(0.5))
                })
            }
        }
        
        level3Selector.selectedHandler = {
            GameManager.sharedInstance.currentlevel = 3

            if GameManager.sharedInstance.unlockedLevel[GameManager.sharedInstance.currentlevel] == true {
                let skView = self.view as SKView!
                
                let scene = GameScene(fileNamed: "GameScene")! as GameScene
                
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            } else {
                self.locked.hidden = false
                self.locked.runAction(SKAction.fadeInWithDuration(0.5), completion:{
                    self.locked.runAction(SKAction.fadeOutWithDuration(0.5))
                })
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
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            touchNode.position.y = touch.locationInNode(self).y * 0.5
            
            levelWallHeight = levelWall.size.height
            levelWallWidth = levelWall.size.width
            levelSelectorCamera!.position.y.clamp(284, -levelWallHeight/4)
        }
    }
}
