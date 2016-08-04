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
    var sound: MSButtonNode!
    var mute: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        play = self.childNodeWithName("play") as! MSButtonNode
        levelSelector = childNodeWithName("levelSelector") as! MSButtonNode
        thunderFlash = childNodeWithName("thunderFlash") as SKNode!
        sound = childNodeWithName("//sound") as! MSButtonNode
        mute = childNodeWithName("//mute") as! MSButtonNode
        
        /* Setup restart button selection handler */
        play.selectedHandler = {
            
            var i = 0
            
            for checkLevel in GameManager.sharedInstance.unlockedLevel {
                if checkLevel == true {
                    i += 1
                } else if checkLevel == false {
                    GameManager.sharedInstance.currentlevel = i
                } else {
                    print("error")
                }
            }
            
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
        let raining = SKAction.playSoundFileNamed("Raining", waitForCompletion: false)
        let rainWait = SKAction.waitForDuration(1)
        addChild(rainEffect)
        let soundSequence = SKAction.sequence([raining, rainWait])
        self.runAction(SKAction.repeatActionForever(soundSequence))
        rainEffect.position = CGPoint(x: 320, y: 568)
        
        /* Intervals for thunder */
        let wait = SKAction.waitForDuration(5, withRange: 10)
        let wait2 = SKAction.waitForDuration(0.2)
        let wait3 = SKAction.waitForDuration(0.1)
        
        let thunderclap = SKAction.playSoundFileNamed("Thunderclap", waitForCompletion: false)

        let block = SKAction.runBlock({
            self.thunderFlash.zPosition = -10

        })
        let lightning = SKAction.runBlock({
            self.runAction(thunderclap)
            self.thunderFlash.zPosition = 10
        })
        
        let sequence = SKAction.sequence([block ,wait, lightning, wait3, block, wait2, lightning, wait3, block, wait])
        self.runAction(SKAction.repeatActionForever(sequence))
    }
}
