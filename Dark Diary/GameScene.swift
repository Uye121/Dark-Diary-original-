//
//  GameScene.swift
//  Dark Diary
//
//  Created by Ulric Ye on 7/11/16.
//  Copyright (c) 2016 TestingDummies@_@. All rights reserved.
//

import SpriteKit
import UIKit

enum GameState {
    case Pause, Playing, GameOver, Victory
}



let resourcePathLight = NSBundle.mainBundle().pathForResource("Light", ofType: "sks")
let light = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePathLight!))
var touchLocation: CGPoint!


class GameScene: SKScene {
    var state: GameState!
    var light1: Light!
    /* width and height of the screen */
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var levelWidth: CGFloat = 0.0
    var levelHeight: CGFloat = 0.0
    /* initializing random x and y coordinates for the pages' position */
    var randomX: Int = 0
    var randomY: Int = 0
    var index = 0
    var collectedNotes = 0
    var levels = 0
    var timeLeft = 45
    var pauseButton: MSButtonNode!
    var playButton: MSButtonNode!
    var restartButton: MSButtonNode!
    var sound: MSButtonNode!
    var mute: MSButtonNode!
    var homeButton: MSButtonNode!
    var nextLevelButton: MSButtonNode!
    var page1: SKSpriteNode!
    var pages:[SKSpriteNode] = []
    var levelNode: SKNode!
    var lightCamera: SKCameraNode!
    var goal: SKLabelNode!
    var lighting: SKLightNode!
    var time: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var victoryLabel: SKLabelNode!
    var pauseLabel: SKLabelNode!
    var levelBackground: SKSpriteNode!
    var pauseBackground: SKSpriteNode!
    var levelScenes: [SKSpriteNode] = []
    var load = true
    
    enum Levels { case Default }
    
    var levelIndex = 0

    var currentLevel: Levels = .Default {
        didSet {
            levelIndex = 0
        }
    }
    
    func levelsStates() {
        while load {
            switch levelIndex % 2 {
            case 0:
                level1()
                load = false
            case 1:
                level2()
                load = false
            default:
                break
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        state = .Playing
        
        levelNode = childNodeWithName("//levelNode")
        /* Add level 1 into the game */
        goal = childNodeWithName("//goal") as! SKLabelNode
        pauseButton = childNodeWithName("//pauseButton") as! MSButtonNode
        playButton = childNodeWithName("//playButton") as! MSButtonNode
        restartButton = childNodeWithName("//restartButton") as! MSButtonNode
        homeButton = childNodeWithName("//homeButton") as! MSButtonNode
        nextLevelButton = childNodeWithName("//nextLevelButton") as! MSButtonNode
        //sound = childNodeWithName("//sound") as! MSButtonNode
        //mute = childNodeWithName("//mute") as! MSButtonNode
        lightCamera = self.childNodeWithName("camera") as! SKCameraNode
        time = self.childNodeWithName("//time") as! SKLabelNode
        gameOverLabel = childNodeWithName("//gameOverLabel") as! SKLabelNode
        victoryLabel = childNodeWithName("//victoryLabel") as! SKLabelNode
        pauseLabel = childNodeWithName("//pauseLabel") as! SKLabelNode
        pauseBackground = childNodeWithName("//pauseBackground") as! SKSpriteNode
        
        levelsStates()
        
        /* scene and background constants */
        screenWidth = size.width
        screenHeight = size.height

        
        /* Add the light into the scene */
        light1 = light.light
        light1.moveToParent(self)
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        
        /* Ensure correct aspect mode */
        scene!.scaleMode = .AspectFit
        goal.text = String("\(collectedNotes)/\(levels)")
        
        /* Timer */
        let wait = SKAction.waitForDuration(1)
        let block = SKAction.runBlock({
            if self.timeLeft > 0 { self.timeLeft -= 1 }
            if self.timeLeft < 11 {
                self.time.fontColor = UIColor.redColor()
            }
            if self.timeLeft == 0 { self.state = .GameOver }
            self.time.text = "\(self.timeLeft)"
        })
        let sequence = SKAction.sequence([wait, block])
        self.runAction(SKAction.repeatActionForever(sequence))
        
        
        pauseButton.selectedHandler = {
            self.state = .Pause
            self.pauseButton.zPosition = -10
            self.playButton.zPosition = 10
            self.pauseLabel.zPosition = 10
            self.homeButton.zPosition = 10
            self.restartButton.zPosition = 10
            self.pauseBackground.zPosition = 5
        }
        
        playButton.selectedHandler = {
            self.state = .Playing
            self.clearSceneOfButtons()
            if self.state == .Playing {
                self.scene!.view!.paused = false
            }
        }
        
        restartButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Restart game scene */
            skView.presentScene(scene)
            
        }
        
        homeButton.selectedHandler = {
            
            /* Grab reference to Spritekit view */
            let skView = self.view as SKView!
            
            /* Load Main menu */
            let scene = MainMenu(fileNamed:"MainMenu") as MainMenu!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
        
        nextLevelButton.selectedHandler = {
            self.scene!.view!.paused = false
            self.victoryLabel.zPosition = -10
            self.timeLeft = 45
            self.collectedNotes = 0
            self.levelNode.removeAllChildren()
            self.state = .Playing
            self.clearSceneOfButtons()
            self.levelIndex += 1
            self.load = true
            self.levelsStates()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        if state == .Pause {
            self.scene!.view!.paused = true
        }
        
        if state == .GameOver {
            gameOverLabel.zPosition = 15
            self.scene!.view!.paused = true
            self.homeButton.zPosition = 10
            self.restartButton.zPosition = 10
            self.pauseBackground.zPosition = 5
        }
        
        if state == .Victory {
            victoryLabel.zPosition = 15
            self.scene!.view!.paused = true
            self.homeButton.zPosition = 10
            self.restartButton.zPosition = 10
            self.pauseBackground.zPosition = 5
            self.nextLevelButton.zPosition = 10
        }
        
        /* Have the light follow the orb */
        lighting.position = light1.position
        
        /* Called before each frame is rendered */
        var i = 0
        
        for checkPage in pages {
            /* Detect frame "collision" */
            if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), checkPage.calculateAccumulatedFrame()) {
                checkPage.removeFromParent()
                pages.removeAtIndex(i)
                collectedNotes += 1
                timeLeft += 5
            }
            i += 1
        }
        
        /* Update the goal #/4 everytime a page is collected */
        goal.text = String("\(collectedNotes)/\(levels)")
        
        if collectedNotes == levels {
            state = .Victory
        }
        
        let cameraViewPortWidth = screenWidth * 0.5
        let cameraViewPortHeight = screenHeight * 0.5
        
        lightCamera.position = light1.position
        lightCamera.position.x.clamp(cameraViewPortWidth, levelWidth - cameraViewPortWidth)
        lightCamera.position.y.clamp(cameraViewPortHeight, levelHeight - cameraViewPortHeight)

        
    }
    
    func createPage() {
        /* Randomly generate the pages' position across the whole map */
//        randomY = Int(arc4random()) % (Int(levelHeight - 10) + 5)
        
        randomX = Int(arc4random_uniform(UInt32(levelWidth - 10)) + 5)
        randomY = Int(arc4random_uniform(UInt32(levelHeight - 10)) + 5)
        /* Add reference of the page to the scene */
        let resourcePathPage = NSBundle.mainBundle().pathForResource("Page", ofType: "sks")
        let pageReference = PageReferenceNode (URL: NSURL (fileURLWithPath: resourcePathPage!))
        
        /* move the whole page file into the gamescene */
        page1 = pageReference.page
        page1.moveToParent(self)
        page1.position = CGPoint(x: randomX, y: randomY)
        
        /* add page into the array of pages */
        pages.append(page1)
    }
    
    func clearSceneOfButtons() {
        playButton.zPosition = -10
        pauseLabel.zPosition = -10
        pauseButton.zPosition = 10
        restartButton.zPosition = -10
        homeButton.zPosition = -10
        pauseBackground.zPosition = -15
        nextLevelButton.zPosition = -10
    }
    
    func level1() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
        let level1 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level1)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level1Background") as! SKSpriteNode
        levels = 4
        index = 0
        
        state = .Playing
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        /* create 4 pages for level 1 */
        while index < levels {
            createPage()
            index += 1
        }
    }
    
    func level2() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level2", ofType: "sks")
        let level2 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level2)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level2Background") as! SKSpriteNode
        levels = 6
        index = 0
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position

        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        while index < levels {
            createPage()
            index += 1
        }
    }

}
