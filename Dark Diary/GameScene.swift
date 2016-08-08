//
//  GameScene.swift
//  Dark Diary
//
//  Created by Ulric Ye on 7/11/16.
//  Copyright (c) 2016 TestingDummies@_@. All rights reserved.
//
import Foundation
import SpriteKit

enum GameState {
    case Pause, Playing, GameOver, Victory
}

let resourcePathLight = NSBundle.mainBundle().pathForResource("Light", ofType: "sks")
let light = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePathLight!))

class GameScene: SKScene {
    var state: GameState!
    var light1: Light!
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var levelWidth: CGFloat = 0.0
    var levelHeight: CGFloat = 0.0
    var randomX: Int = 0
    var randomY: Int = 0
    var numberOfPages: Int = 0
    var numberOfBoxes: Int = 0
    var collectedNotes = 0
    var totalPages = 0
    var timeLeft = 45
    var bombTime = 20
    var randomPosition: CGPoint!
    var currentPosition: CGPoint!
    var distanceTraveledX: CGFloat!
    var distanceTraveledY: CGFloat!
    var distanceTraveled: Double!
    var distanceX: CGFloat!
    var distanceY: CGFloat!
    var pauseButton: MSButtonNode!
    var playButton: MSButtonNode!
    var restartButton: MSButtonNode!
    var homeButton: MSButtonNode!
    var nextLevelButton: MSButtonNode!
    var levelSelector: MSButtonNode!
    var page1: SKSpriteNode!
    var pages:[SKSpriteNode] = []
    var randomBox: SKSpriteNode!
    var randomBoxes: [SKSpriteNode] = []
    var bomb: SKSpriteNode!
    var bombTimer: SKLabelNode!
    var bombArray: [SKSpriteNode] = []
    var killer: SKSpriteNode!
    var levelNode: SKNode!
    var lightCamera: SKCameraNode!
    var goal: SKLabelNode!
    var lighting: SKLightNode!
    var time: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var victoryLabel: SKLabelNode!
    var pauseLabel: SKLabelNode!
    var diffuseMessage: SKLabelNode!
    var levelBackground: SKSpriteNode!
    var pauseBackground: SKSpriteNode!
    var explode: SKSpriteNode!
    var levelScenes: [SKSpriteNode] = []
    var load = true
    var bombTimeAction: SKAction!
    let defaults = NSUserDefaults.standardUserDefaults()
    var doneMoving = true
    let circle = SKShapeNode(circleOfRadius:100)
    
    enum Levels { case Default }
    
    /* Manages changing to different level */
    func levelsStates() {
        while load {
            switch GameManager.sharedInstance.currentlevel % 4 {
            case 1:
                level1()
                load = false
            case 2:
                level2()
                load = false
            case 3:
                level3()
                load = false
            default:
                break
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        state = .Playing
        
        levelNode = childNodeWithName("//levelNode")
        goal = childNodeWithName("//goal") as! SKLabelNode
        pauseButton = childNodeWithName("//pauseButton") as! MSButtonNode
        playButton = childNodeWithName("//playButton") as! MSButtonNode
        restartButton = childNodeWithName("//restartButton") as! MSButtonNode
        homeButton = childNodeWithName("//homeButton") as! MSButtonNode
        nextLevelButton = childNodeWithName("//nextLevelButton") as! MSButtonNode
        levelSelector = childNodeWithName("//levelSelector") as! MSButtonNode
        lightCamera = self.childNodeWithName("camera") as! SKCameraNode
        time = self.childNodeWithName("//time") as! SKLabelNode
        gameOverLabel = childNodeWithName("//gameOverLabel") as! SKLabelNode
        victoryLabel = childNodeWithName("//victoryLabel") as! SKLabelNode
        pauseLabel = childNodeWithName("//pauseLabel") as! SKLabelNode
        diffuseMessage = childNodeWithName("//diffuseMessage") as! SKLabelNode
        pauseBackground = childNodeWithName("//pauseBackground") as! SKSpriteNode
        explode = childNodeWithName("//explode") as! SKSpriteNode
        
        /* scene and background constants */
        screenWidth = size.width
        screenHeight = size.height
        
        /* Add the light into the scene */
        light1 = light.light
        light1.moveToParent(self)
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        levelsStates()
        
        /* Ensure correct aspect mode */
        scene!.scaleMode = .AspectFit
        goal.text = String("\(collectedNotes)/\(totalPages)")
        explode.zPosition = -10
        
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
        
        circle.zPosition = -20
        self.addChild(circle)
        
        pauseButton.selectedHandler = {
            self.state = .Pause
            self.pauseButton.zPosition = -10
            self.playButton.zPosition = 10
            self.pauseLabel.zPosition = 10
            self.homeButton.zPosition = 10
            self.restartButton.zPosition = 10
            self.levelSelector.zPosition = 10
            self.pauseBackground.zPosition = 5
        }
        
        playButton.selectedHandler = {
            self.state = .Playing
            self.clearSceneOfButtons()
            self.playButton.zPosition = -10
            self.pauseLabel.zPosition = -10
            self.pauseButton.zPosition = 10
            self.restartButton.zPosition = -10
            self.homeButton.zPosition = -10
            self.levelSelector.zPosition = -10
            self.pauseBackground.zPosition = -15
            if self.state == .Playing {
                self.scene!.view!.paused = false
            }
        }
        
        restartButton.selectedHandler = {
            if self.state == .Victory {
                GameManager.sharedInstance.currentlevel -= 1
            }
            
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
            self.goal.fontColor = UIColor.redColor()
            self.victoryLabel.zPosition = -10
            self.timeLeft = 45
            self.collectedNotes = 0
            self.levelNode.removeAllChildren()
            self.state = .Playing
            self.clearSceneOfButtons()
            
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
            self.load = true
            self.levelsStates()
        }
        
        levelSelector.selectedHandler = {
            let skView = self.view as SKView!
            
            let scene = LevelSelect(fileNamed: "LevelSelect") as LevelSelect!
            
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Use NSUserdefault to memorize info */
        defaults.setObject(GameManager.sharedInstance.unlockedLevel, forKey: "saveUnlockedLevel")
        GameManager.sharedInstance.unlockedLevel = defaults.objectForKey("saveUnlockedLevel") as? [Bool] ?? [Bool]()
        
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
            GameManager.sharedInstance.unlockedLevel[GameManager.sharedInstance.currentlevel] = true
            GameManager.sharedInstance.currentlevel += 1
            goal.fontColor = UIColor.greenColor()
            victoryLabel.zPosition = 15
            self.scene!.view!.paused = true
            self.homeButton.zPosition = 10
            self.restartButton.zPosition = 10
            self.pauseBackground.zPosition = 5
            self.nextLevelButton.zPosition = 10
            
            // Show interstitial at location HomeScreen. See Chartboost.h for available location options.
            Chartboost.showInterstitial(CBLocationHomeScreen)
        }
        
        /* Have the light follow the orb */
        lighting.position = light1.position
        
        var i = 0
        var j = 0
        var k = 0
        
        for checkPage in pages {
            /* Detect light and page "collision" */
            if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), checkPage.calculateAccumulatedFrame()) {
                /* Code connect: flame effects */
                let flame = SKEmitterNode(fileNamed: "CollectEffect")
                /* Limits how many flame particle is emitted */
                flame?.numParticlesToEmit = 35
                /* Add flame to the page that intersect with the light */
                flame!.position = pages[i].position
                checkPage.removeFromParent()
                pages.removeAtIndex(i)
                addChild(flame!)
                collectedNotes += 1
            }
            i += 1
        }
        
        for checkBoxes in randomBoxes {
            /* Detect light and box "collision */
            if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), checkBoxes.calculateAccumulatedFrame()) {
                let rand = CGFloat.random(min: 0, max: 1.0)
                /* Change the color of time's font to red, white, or green */
                let colorizeRed = SKAction.runBlock({
                    self.time.fontColor = SKColor.redColor()
                })
                let colorizeWhite = SKAction.runBlock({
                    self.time.fontColor = SKColor.whiteColor()
                })
                let colorizeGreen = SKAction.runBlock({
                    self.time.fontColor = SKColor.greenColor()
                })
                let waitToChangeColor = SKAction.waitForDuration(2.0)
                let colorizeRedSequence = SKAction.sequence([colorizeRed, waitToChangeColor, colorizeWhite])
                let colorizeGreenSequence = SKAction.sequence([colorizeGreen, waitToChangeColor, colorizeWhite])
                
                /* Random box gives random outcomes */
                if rand < 0.45 {
                    timeLeft -= 5
                    time.runAction(colorizeRedSequence)
                } else if rand < 0.5 {
                    lighting.falloff = 0.8
                } else if rand < 0.55 {
                    timeLeft = timeLeft/2
                    time.runAction(colorizeRedSequence)
                } else {
                    timeLeft += 3
                    time.runAction(colorizeGreenSequence)
                    
                }
                checkBoxes.removeFromParent()
                randomBoxes.removeAtIndex(j)
            }
            j += 1
        }
        
        for checkBomb in bombArray {
            if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), bomb.calculateAccumulatedFrame()) && bombTime > 0 {
                diffuseMessage.zPosition = 5
                let fadeIn = SKAction.runBlock {
                    self.diffuseMessage.runAction(SKAction.fadeInWithDuration(1.0))
                }
                let wait = SKAction.waitForDuration(1)
                let fadeOut = SKAction.runBlock {
                    self.diffuseMessage.runAction(SKAction.fadeOutWithDuration(1.0))
                }
                let sequence = SKAction.sequence([fadeIn, wait, fadeOut])
                diffuseMessage.runAction(sequence)
                checkBomb.removeFromParent()
                bombArray.removeAtIndex(k)
                bombTimer.removeAllActions()
                self.timeLeft -= 5
            }
            k += 1
        }
        
        if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), killer.calculateAccumulatedFrame()) {
            state = .GameOver
        }
        
        /* Update the goal collected pages/total pages needed everytime a page is collected */
        goal.text = String("\(collectedNotes)/\(totalPages)")
        
        if collectedNotes == totalPages {
            state = .Victory
        }
        
        /* Half of the game scene's width and height */
        let cameraViewPortWidth = screenWidth * 0.5
        let cameraViewPortHeight = screenHeight * 0.5
        
        /* Clamp camera position */
        lightCamera.position = light1.position
        lightCamera.position.x.clamp(cameraViewPortWidth, levelWidth - cameraViewPortWidth)
        lightCamera.position.y.clamp(cameraViewPortHeight, levelHeight - cameraViewPortHeight)
        
        detect(killer, circle)
        moveKillerRandomly(killer)
    }
    
    func createPage() {
        
        /* Randomly generate the pages' position across the whole map */
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
    
    func createRandomBox() {
        randomX = Int(arc4random_uniform(UInt32(levelWidth - 10)) + 5)
        randomY = Int(arc4random_uniform(UInt32(levelHeight - 10)) + 5)
        
        /* Connects the box sks file to the GameScene */
        let resourcePathBox = NSBundle.mainBundle().pathForResource("RandomBox", ofType: "sks")
        let boxReference = BoxReferenceNode (URL: NSURL (fileURLWithPath: resourcePathBox!))
        
        randomBox = boxReference.randomBox
        randomBox.moveToParent(self)
        randomBox.position = CGPoint(x: randomX, y: randomY)
        
        randomBoxes.append(randomBox)
    }
    
    func createBomb() {
        randomX = Int(arc4random_uniform(UInt32(levelWidth - 10)) + 5)
        randomY = Int(arc4random_uniform(UInt32(levelHeight - 10)) + 5)
        
        /* Connects the bomb sks file to the GameScene */
        let resourcePathBomb = NSBundle.mainBundle().pathForResource("Bomb", ofType: "sks")
        let bombReference = BombReferenceNode (URL: NSURL (fileURLWithPath: resourcePathBomb!))
        
        bomb = bombReference.bomb
        bomb.moveToParent(self)
        bomb.position = CGPoint(x: randomX, y: randomY)
        bomb.alpha = 0.5
        
        bombArray.append(bomb)
    }
    
    func spawnKiller() {
        let resourcePathKiller = NSBundle.mainBundle().pathForResource("Killer", ofType: "sks")
        let killerReference = KillerReferenceNode (URL: NSURL (fileURLWithPath: resourcePathKiller!))
        
        killer = killerReference.killer
        killer.moveToParent(self)
        killer.position = CGPoint(x: levelWidth - 40, y: levelHeight - 40)
    }
    
    func moveKillerRandomly(killer: SKSpriteNode) {
        let killerMovement = SKAction.runBlock({
            self.randomPosition = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.levelWidth))), y: CGFloat(arc4random_uniform(UInt32(self.levelHeight))))
            self.currentPosition = killer.position
            self.distanceTraveledX = abs(self.currentPosition.x - self.randomPosition.x)
            self.distanceTraveledY = abs(self.currentPosition.y - self.randomPosition.y)
            self.distanceTraveled = (sqrt(Double(pow(self.distanceTraveledX, 2)) + Double(pow(self.distanceTraveledY, 2))))
            let move = SKAction.moveTo(self.randomPosition, duration: self.distanceTraveled/160)
            killer.runAction(move)
        })
        
        if randomPosition == nil || killer.position == randomPosition && detect(killer, circle) == false {
            killer.runAction(killerMovement)
        } else if detect(killer, circle)  == true {
            distanceX = abs(self.currentPosition.x - self.light1.position.x)
            distanceY = abs(self.currentPosition.y - self.light1.position.y)
            let displacement = (sqrt(Double(pow(self.distanceX, 2)) + Double(pow(self.distanceY, 2))))
            killer.runAction(SKAction.moveTo(light1.position, duration: displacement/80))
        }
        
    }
    
    func clearSceneOfButtons() {
        playButton.zPosition = -10
        pauseLabel.zPosition = -10
        pauseButton.zPosition = 10
        restartButton.zPosition = -10
        homeButton.zPosition = -10
        pauseBackground.zPosition = -15
        nextLevelButton.zPosition = -10
        levelSelector.zPosition = -10
    }
    
    func spawnOutside() {
        /* Ensures that the pages do not spawn inside the screen in the beginning */
        for checkPagePosition in 0..<numberOfPages {
            if pages[checkPagePosition].position.x < screenWidth && pages[checkPagePosition].position.y < screenHeight {
                pages[checkPagePosition].removeFromParent()
                pages.removeAtIndex(checkPagePosition)
                numberOfPages -= 1
            }
        }
    }
    
    func destruction() {
        /* Code connect: bomb counting down */
        let bombBeep = SKAction.playSoundFileNamed("beep", waitForCompletion: false)
        let explodingNoise = SKAction.playSoundFileNamed("ExplodingNoise", waitForCompletion: false)
        let wait = SKAction.waitForDuration(1.0)
        let wait2 = SKAction.waitForDuration(2.0)
        let block = SKAction.runBlock({
            if self.bombTime > 0 {
                self.bombTime -= 1
                if GameManager.sharedInstance.music == true {
                    self.bomb.runAction(bombBeep)
                }
            }
            if self.bombTime < 4 {
                self.bombTimer.fontColor = UIColor.redColor()
            }
            if self.bombTime == 0 {
                self.explode.zPosition = 2
                let fadeIn = SKAction.runBlock {
                    self.explode.runAction(SKAction.fadeInWithDuration(1.0), completion: {
                        let fadeOut = SKAction.runBlock {
                            self.explode.runAction(SKAction.fadeOutWithDuration(1.0))
                        }
                        self.runAction(fadeOut)
                    })
                }
                
                let bombing = SKAction.sequence([fadeIn, explodingNoise, wait2])
                
                self.bomb.runAction(bombing, completion: {
                    self.state = .GameOver
                })
                /* To prevent this part of the code from repeating forever */
                self.bombTime -= 1
            }
            self.bombTimer.text = "\(self.bombTime)"
        })
        let sequence = SKAction.sequence([wait, block])
        bombTimeAction = SKAction.repeatActionForever(sequence)
        bombTimer.runAction(bombTimeAction)
    }
    
    func detect(killer: SKSpriteNode, _ detector: SKShapeNode) -> Bool {
        detector.position = killer.position
        
        if CGRectIntersectsRect(light1.calculateAccumulatedFrame(),
                                detector.calculateAccumulatedFrame()) {
            return true
        } else {
            return false
        }
    }
}


