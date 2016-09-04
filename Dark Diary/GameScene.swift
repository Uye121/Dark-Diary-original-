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
    var timeLeft = 46
    var bombTime = 20
    var exitCheck: Bool = true
    var randomPosition: CGPoint!
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
    var helpButton: MSButtonNode!
    var page1: SKSpriteNode!
    var phantomPage: SKSpriteNode!
    var pages:[SKSpriteNode] = []
    var randomBox: SKSpriteNode!
    var randomBoxes: [SKSpriteNode] = []
    var bomb: SKSpriteNode!
    var bombTimer: SKLabelNode!
    var bombArray: [SKSpriteNode] = []
    var killer: SKSpriteNode!
    var exit: SKSpriteNode!
    var fire1: SKSpriteNode!
    var fire2: SKSpriteNode!
    var levelNode: SKNode!
    var lightCamera: SKCameraNode!
    var goal: SKLabelNode!
    var lighting: SKLightNode!
    var lighting2: SKLightNode!
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
    let circle = SKShapeNode(circleOfRadius:200)
    var help: SKReferenceNode!
    var exitSign: SKLabelNode!
    var reflect: SKLabelNode!
    
    // Thoughts connections
    var reflect2: SKLabelNode!
    
    enum Levels { case Default }
    
    /* Manages changing to different level */
    
    func levelsStates() {
        while load {
            switch GameManager.sharedInstance.currentlevel % 8 {
            case 1:
                level1()
                load = false
            case 2:
                level2()
                load = false
            case 3:
                level3()
                load = false
            case 4:
                level4()
                load = false
            case 5:
                level5()
                load = false
            case 6:
                level6()
                load = false
            case 7:
                comingSoon()
                load = false
            default:
                break
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        state = .Playing
        if GameManager.sharedInstance.currentlevel == 0 {
            GameManager.sharedInstance.currentlevel = 1
        }
        
        levelNode = childNodeWithName("//levelNode")
        goal = childNodeWithName("//goal") as! SKLabelNode
        pauseButton = childNodeWithName("//pauseButton") as! MSButtonNode
        playButton = childNodeWithName("//playButton") as! MSButtonNode
        restartButton = childNodeWithName("//restartButton") as! MSButtonNode
        homeButton = childNodeWithName("//homeButton") as! MSButtonNode
        nextLevelButton = childNodeWithName("//nextLevelButton") as! MSButtonNode
        levelSelector = childNodeWithName("//levelSelector") as! MSButtonNode
        helpButton = childNodeWithName("//helpButton") as! MSButtonNode
        lightCamera = self.childNodeWithName("camera") as! SKCameraNode
        time = self.childNodeWithName("//time") as! SKLabelNode
        gameOverLabel = childNodeWithName("//gameOverLabel") as! SKLabelNode
        victoryLabel = childNodeWithName("//victoryLabel") as! SKLabelNode
        pauseLabel = childNodeWithName("//pauseLabel") as! SKLabelNode
        diffuseMessage = childNodeWithName("//diffuseMessage") as! SKLabelNode
        pauseBackground = childNodeWithName("//pauseBackground") as! SKSpriteNode
        explode = childNodeWithName("//explode") as! SKSpriteNode
        help = childNodeWithName("//help") as! SKReferenceNode
        exitSign = childNodeWithName("//exitSign") as! SKLabelNode
        
        help.hidden = true
        
        if GameManager.sharedInstance.currentlevel != 7 {
            /* scene and background constants */
            screenWidth = size.width
            screenHeight = size.height
            
            /* Add the light into the scene */
            light1 = light.light
            light1.moveToParent(self)
            light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        }
        
        levelsStates()
        exitSign.hidden = true
        ///// Thoughts code connection
        if GameManager.sharedInstance.currentlevel >= 5 && reflect2 != nil {
            reflect2 = childNodeWithName("//reflect2") as! SKLabelNode
            reflect2.hidden = true
        }
        
        if GameManager.sharedInstance.currentlevel != 7 {
            /* Ensure correct aspect mode */
            scene!.scaleMode = .AspectFit
            goal.text = String("\(collectedNotes)/\(pages.count + collectedNotes)")
            explode.zPosition = -10
            
            /* Timer */
            let wait = SKAction.waitForDuration(1)
            let block = SKAction.runBlock({
                if self.timeLeft > 0 { self.timeLeft -= 1 }
                if self.timeLeft < 11 {
                    self.time.fontColor = UIColor.redColor()
                }
                if self.timeLeft <= 0 { self.state = .GameOver }
                self.time.text = "\(self.timeLeft)"
            })
            let sequence = SKAction.sequence([wait, block])
            self.runAction(SKAction.repeatActionForever(sequence))
            
            circle.zPosition = -20
            self.addChild(circle)
        }
        
        pauseButton.selectedHandler = {
            self.state = .Pause
            self.pauseButton.zPosition = -10
            self.playButton.zPosition = 10
            self.pauseLabel.zPosition = 10
            self.homeButton.zPosition = 10
            self.restartButton.zPosition = 10
            self.levelSelector.zPosition = 10
            self.pauseBackground.zPosition = 5
            self.helpButton.zPosition = 10
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
            self.helpButton.zPosition = -10
            self.scene!.view!.paused = false
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
        
        helpButton.selectedHandler = {
            self.state = .Playing
            self.scene!.view!.paused = false
            
            self.help.hidden = false
            self.state = .Pause
            
            let returnButton = self.childNodeWithName("//returnButton") as! MSButtonNode
            
            returnButton.selectedHandler = {
                self.help.hidden = true
                self.state = .Playing
                self.scene!.view!.paused = false
                self.clearSceneOfButtons()
                self.playButton.zPosition = -10
                self.pauseLabel.zPosition = -10
                self.pauseButton.zPosition = 10
                self.restartButton.zPosition = -10
                self.homeButton.zPosition = -10
                self.levelSelector.zPosition = -10
                self.pauseBackground.zPosition = -15
                self.helpButton.zPosition = -10
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        let resourcePathExit = NSBundle.mainBundle().pathForResource("Exit", ofType: "sks")
        let exitReference = exitReferenceNode (URL: NSURL (fileURLWithPath: resourcePathExit!))
        
        if GameManager.sharedInstance.currentlevel == 0 {
            GameManager.sharedInstance.currentlevel = 1
        }
        
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
            
            
        }
        
        if GameManager.sharedInstance.currentlevel != 7 {
            /* Have the light follow the orb */
            lighting.position = light1.position
            exitSign.position.x = lighting.position.x - 0.061
            exitSign.position.y = lighting.position.y + 34.692
            
            if killer != nil {
                moveKillerRandomly(killer)
            }
            
            var i = 0
            var j = 0
            var k = 0
            
            /* Make phantomPages appear only when the other fire is active */
            if phantomPage != nil {
                if levelBackground.lightingBitMask == 1 {
                    for checkPage in pages {
                        if checkPage.name == "page" {
                            checkPage.hidden = false
                        } else if checkPage.name == "phantomPage" {
                            checkPage.hidden = true
                        }
                    }
                } else if levelBackground.lightingBitMask == 2 {
                    for checkPage in pages {
                        if checkPage.name == "page" {
                            checkPage.hidden = true
                        } else if checkPage.name == "phantomPage" {
                            checkPage.hidden = false
                        }
                    }
                }
            }
            
            for checkPage in pages {
                /* Detect light and page "collision" */
                if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), checkPage.calculateAccumulatedFrame()) {
                    if checkPage.name == "page" && levelBackground.lightingBitMask == 1{
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
                    } else if checkPage.name == "phantomPage" && levelBackground.lightingBitMask == 2 {
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
                } else {
                    i += 1
                }
            }
            
            if randomBox != nil {
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
                    } else {
                        j += 1
                    }
                }
            }
            
            if bomb != nil {
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
                    } else {
                        k += 1
                    }
                }
            }
            
            if killer != nil {
                if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), killer.calculateAccumulatedFrame()) {
                    state = .GameOver
                }
            }
            
            /* Update the goal collected pages/total pages needed everytime a page is collected */
            goal.text = String("\(collectedNotes)/\(pages.count + collectedNotes)")
            
            if collectedNotes == pages.count + collectedNotes && exitCheck == true {
                /* Make the signal for players to find exit appear */
                exitSign.hidden = false
                
                /* Make exit appear */
                exit = exitReference.exit
                exit.moveToParent(levelNode)
                if GameManager.sharedInstance.currentlevel == 1 {
                    exit.position = CGPoint(x:718.5, y:391.546)
                } else if GameManager.sharedInstance.currentlevel == 2 {
                    exit.position = CGPoint(x:622.22, y:435.624)
                } else if GameManager.sharedInstance.currentlevel == 3 {
                    exit.position = CGPoint(x:570.27, y:434.772)
                } else if GameManager.sharedInstance.currentlevel == 4 {
                    exit.position = CGPoint(x:107.258, y:189.524)
                }
                exit.zPosition = 1
                
                
                if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), exit.calculateAccumulatedFrame()) {
                    // Show interstitial ats location HomeScreen. See Chartboost.h for available location options.
                    exitCheck = false
                    Chartboost.showInterstitial(CBLocationHomeScreen)
                    state = .Victory
                }
            }
            blinking(exitSign)
            
            // Changes the fire
            if fire2 != nil && fire1 != nil {
                if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), fire2.calculateAccumulatedFrame()) {
                    levelBackground.lightingBitMask = 2
                } else if CGRectIntersectsRect(light1.calculateAccumulatedFrame(), fire1.calculateAccumulatedFrame()) {
                    levelBackground.lightingBitMask = 1
                }
            }
            if lighting2 != nil {
                fireExchange()
            }
            
            /* Half of the game scene's width and height */
            let cameraViewPortWidth = screenWidth * 0.5
            let cameraViewPortHeight = screenHeight * 0.5
            
            /* Clamp camera position */
            lightCamera.position = light1.position
            lightCamera.position.x.clamp(cameraViewPortWidth, levelWidth - cameraViewPortWidth)
            lightCamera.position.y.clamp(cameraViewPortHeight, levelHeight - cameraViewPortHeight)
            
            ////// Self-thoughts //////
            if GameManager.sharedInstance.currentlevel >= 5 && reflect2 != nil {
                if collectedNotes == 10 {
                    reflect2.moveToParent(camera!)
                    reflect2.position = CGPoint(x: 4.328, y: 40)
                    reflect2.hidden = false
                    reflect2.runAction(SKAction.fadeInWithDuration(1))
                    reflect2.runAction(SKAction.fadeOutWithDuration(1))
                }
            }
        }
        
        if GameManager.sharedInstance.guide == true && reflect != nil && GameManager.sharedInstance.currentlevel == 1 {
            reflect.runAction(SKAction.fadeOutWithDuration(2))
        }
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
    
    func createPhantomPage() {
        /* Randomly generate the pages' position across the whole map */
        randomX = Int(arc4random_uniform(UInt32(levelWidth - 10)) + 5)
        randomY = Int(arc4random_uniform(UInt32(levelHeight - 10)) + 5)
        /* Add reference of the page to the scene */
        let resourcePathPhantomPage = NSBundle.mainBundle().pathForResource("PhantomPage", ofType: "sks")
        let phantomPageReference = PhantomPageReferenceNode (URL: NSURL (fileURLWithPath: resourcePathPhantomPage!))
        
        /* move the whole page file into the gamescene */
        phantomPage = phantomPageReference.phantomPage
        phantomPage.moveToParent(self)
        phantomPage.position = CGPoint(x: randomX, y: randomY)
        
        /* add page into the array of pages */
        pages.append(phantomPage)
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
            self.distanceTraveledX = abs(killer.position.x - self.randomPosition.x)
            self.distanceTraveledY = abs(killer.position.y - self.randomPosition.y)
            self.distanceTraveled = (sqrt(Double(pow(self.distanceTraveledX, 2)) + Double(pow(self.distanceTraveledY, 2))))
            let move = SKAction.moveTo(self.randomPosition, duration: self.distanceTraveled/170)
            killer.runAction(move)
        })
        
        if (randomPosition == nil || killer.position == randomPosition) {
            killer.runAction(killerMovement)
        } else if detect(killer, circle)  == true {
            distanceX = abs(killer.position.x - self.light1.position.x)
            distanceY = abs(killer.position.y - self.light1.position.y)
            let displacement = (sqrt(Double(pow(self.distanceX, 2)) + Double(pow(self.distanceY, 2))))
            killer.runAction(SKAction.moveTo(light1.position, duration: displacement/160), completion: {
                if self.detect(self.killer, self.circle) == false {
                    self.randomPosition = nil
                }
            })
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
        helpButton.zPosition = -10
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
            lighting.ambientColor = UIColor.redColor()
            return true
        } else {
            lighting.ambientColor = UIColor.blackColor()
            return false
        }
    }
    
    func spawnFire() {
        let resourcePathFire1 = NSBundle.mainBundle().pathForResource("Fire1", ofType: "sks")
        let fire1Reference = Fire1ReferenceNode (URL: NSURL (fileURLWithPath: resourcePathFire1!))
        fire1 = fire1Reference.fire1
        fire1.moveToParent(self)
        let resourcePathKiller = NSBundle.mainBundle().pathForResource("Fire2", ofType: "sks")
        let fire2Reference = Fire2ReferenceNode (URL: NSURL (fileURLWithPath: resourcePathKiller!))
        fire2 = fire2Reference.fire2
        fire2.moveToParent(self)
    }
    
    func fireExchange() {
        if levelBackground.lightingBitMask == 1 {
            fire1.hidden = true
            fire2.hidden = false
            lighting.position = light1.position
            if GameManager.sharedInstance.currentlevel == 5 {
                lighting2.position = CGPoint(x: 342.5, y: 619.91)
            }
        } else if levelBackground.lightingBitMask == 2 {
            fire1.hidden = false
            fire2.hidden = true
            lighting2.position = light1.position
            if GameManager.sharedInstance.currentlevel == 5 {
                lighting.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
            }
        }
    }
    
    func blinking(label: SKLabelNode) {
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let blinkSequence = SKAction.sequence([fadeIn, fadeOut])
        let blinkForever = SKAction.repeatActionForever(blinkSequence)
        label.runAction(blinkForever)
    }
}


