//
//  MainMenu.swift
//  Dark Diary
//
//  Created by Ulric Ye on 7/14/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    /* UI Connections */
    var time: Int = 0
    var play: MSButtonNode!
    var levelSelector: MSButtonNode!
    var thunderFlash: SKNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        play = self.childNodeWithName("play") as! MSButtonNode
        levelSelector = childNodeWithName("levelSelector") as! MSButtonNode
        thunderFlash = childNodeWithName("thunderFlash") as SKNode!
        
        /* Setup restart button selection handler */
        play.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        levelSelector.selectedHandler = {
            let skView = self.view as SKView!
            
            let scene = LevelSelect(fileNamed: "LevelSelect") as LevelSelect!
            
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
        let rainPath = NSBundle.mainBundle().pathForResource("rain", ofType: "sks")
        let rainEffect = NSKeyedUnarchiver.unarchiveObjectWithFile(rainPath!) as! SKEmitterNode
        addChild(rainEffect)
        rainEffect.position = CGPoint(x: 320, y: 568)
        
        /* Intervals for thunder */
        let wait = SKAction.waitForDuration(5, withRange: 10)
        let wait2 = SKAction.waitForDuration(0.2)
        let wait3 = SKAction.waitForDuration(0.1)

        let block = SKAction.runBlock({
            self.thunderFlash.zPosition = -10

        })
        let lightning = SKAction.runBlock({
            self.thunderFlash.zPosition = 10
        })
        
        let sequence = SKAction.sequence([block ,wait, lightning, wait3, block, wait2, lightning, wait3, block, wait])
        self.runAction(SKAction.repeatActionForever(sequence))
        
    }
}
