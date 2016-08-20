//
//  MainMenu.swift
//  Dark Diary
//
//  Created by Ulric Ye on 8/1/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import SpriteKit

class LevelSelect: SKScene {
    var page1: SKSpriteNode!
    var page2: SKSpriteNode!
    var page: Int = 1
    var level1Selector: MSButtonNode!
    var level2Selector: MSButtonNode!
    var level3Selector: MSButtonNode!
    var level4Selector: MSButtonNode!
    var level5Selector: MSButtonNode!
    var level6Selector: MSButtonNode!
    var returnButton: MSButtonNode!
    var nextButton: MSButtonNode!
    var locked: SKLabelNode!
    var levelWallHeight: CGFloat!
    var levelWallWidth: CGFloat!
    
    override func didMoveToView(view: SKView) {
        /* Connect the buttons */
        page1 = childNodeWithName("page1") as! SKSpriteNode
        page2 = childNodeWithName("page2") as! SKSpriteNode
        level1Selector = childNodeWithName("//level1Selector") as! MSButtonNode
        level2Selector = childNodeWithName("//level2Selector") as! MSButtonNode
        level3Selector = childNodeWithName("//level3Selector") as! MSButtonNode
        level4Selector = childNodeWithName("//level4Selector") as! MSButtonNode
        level5Selector = childNodeWithName("//level5Selector") as! MSButtonNode
        level6Selector = childNodeWithName("//level6Selector") as! MSButtonNode
        returnButton = childNodeWithName("//returnButton") as! MSButtonNode
        nextButton = childNodeWithName("//nextButton") as! MSButtonNode
        locked = childNodeWithName("//locked") as! SKLabelNode
        
        locked.hidden = true
        page2.hidden = true
        page2.position = CGPoint(x: 160, y: 284)
        
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
        
        level4Selector.selectedHandler = {
            GameManager.sharedInstance.currentlevel = 4
            
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
        
        level5Selector.selectedHandler = {
            GameManager.sharedInstance.currentlevel = 5
            
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
        
        level6Selector.selectedHandler = {
            GameManager.sharedInstance.currentlevel = 6
            
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
        
        returnButton.selectedHandler = {
            if self.page == 1 {
                let skView = self.view as SKView!
                
                let scene = MainMenu(fileNamed: "MainMenu")! as MainMenu
                
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            } else if self.page == 2 {
                self.page1.hidden = false
                self.page2.hidden = true
                self.page -= 1
            }
        }
        
        nextButton.selectedHandler = {
            if self.page == 1 {
                self.page1.hidden = true
                self.page2.hidden = false
                self.page += 1
            }
        }
        
    }
}
