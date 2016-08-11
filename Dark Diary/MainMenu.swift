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
    var helpButton: MSButtonNode!
    var raining: SKAudioNode!
    var thunderclap: SKAudioNode!
    var help: SKReferenceNode!
    
    override func didMoveToView(view: SKView) {
        
        
        /* Setup your scene here */
        
        if GameManager.sharedInstance.unlockedLevel.count != 0{
            for _ in 1...4 {
                if GameManager.sharedInstance.unlockedLevel.count <= 4 {
                    GameManager.sharedInstance.unlockedLevel.append(false)
                }
            }
        }
        
        
        /* Set UI connections */
        play = self.childNodeWithName("play") as! MSButtonNode
        levelSelector = childNodeWithName("levelSelector") as! MSButtonNode
        thunderFlash = childNodeWithName("thunderFlash") as SKNode!
        sound = childNodeWithName("//sound") as! MSButtonNode
        mute = childNodeWithName("//mute") as! MSButtonNode
        helpButton = childNodeWithName("//helpButton") as! MSButtonNode
        raining = childNodeWithName("raining") as! SKAudioNode
        thunderclap = childNodeWithName("thunderclap") as! SKAudioNode
        help = childNodeWithName("//help") as! SKReferenceNode
        
        help.hidden = true
        
        if GameManager.sharedInstance.music == true{
            sound.hidden = true
            mute.hidden = false
        } else {
            sound.hidden = false
            mute.hidden = true
        }
        
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
            scene.scaleMode = .AspectFit
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        levelSelector.selectedHandler = {
            let skView = self.view as SKView!
            
            let scene = LevelSelect(fileNamed: "LevelSelect") as LevelSelect!
            
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
        
        let rainPath = NSBundle.mainBundle().pathForResource("rain", ofType: "sks")
        let rainEffect = NSKeyedUnarchiver.unarchiveObjectWithFile(rainPath!) as! SKEmitterNode
        addChild(rainEffect)
        rainEffect.position = CGPoint(x: 320, y: 568)
        
        mute.selectedHandler = {
            self.sound.hidden = false
            self.mute.hidden = true
            GameManager.sharedInstance.music = false
        }
        
        sound.selectedHandler = {
            self.mute.hidden = false
            self.sound.hidden = true
            GameManager.sharedInstance.music = true
        }
        
        helpButton.selectedHandler = {
            self.help.hidden = false
            
            let returnButton = self.childNodeWithName("//returnButton") as! MSButtonNode
            returnButton.selectedHandler = {
                self.help.hidden = true
            }
        }
        
        /* Intervals for thunder */
        let wait = SKAction.waitForDuration(5, withRange: 10)
        let wait2 = SKAction.waitForDuration(0.2)
        let wait3 = SKAction.waitForDuration(0.1)
        
        let block = SKAction.runBlock({
            self.thunderFlash.zPosition = -10
            
        })
        let lightning = SKAction.runBlock({
            if GameManager.sharedInstance.music == true {
                let thunderclap1 = SKAction.play()
                let waitTime = SKAction.waitForDuration(2.0)
                let silence = SKAction.stop()
                
                let thunderSequence = SKAction.sequence([thunderclap1, waitTime, silence])
                self.thunderclap.runAction(thunderSequence)
            } else {
                self.thunderclap.runAction(SKAction.stop())
            }
            self.thunderFlash.zPosition = 10
        })
        
        let sequence = SKAction.sequence([block ,wait, lightning, wait3, block, wait2, lightning, wait3, block, wait])
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if GameManager.sharedInstance.music == true {
            self.raining.runAction(SKAction.play())
        } else if GameManager.sharedInstance.music == false {
            self.raining.runAction(SKAction.stop())
        }
    }
}
