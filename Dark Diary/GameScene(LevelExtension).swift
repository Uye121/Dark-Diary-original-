//
//  GameScene(LevelExtension).swift
//  Dark Diary
//
//  Created by Ulric Ye on 8/2/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func level1() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
        let level1 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level1)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level1Background") as! SKSpriteNode
        reflect = childNodeWithName("//reflect") as! SKLabelNode
        totalPages = 6
        numberOfPages = 0
        numberOfBoxes = 0
        
        state = .Playing
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        //        exit.position = CGPoint(x:718.5, y:391.546)
        
        /* Create pages and boxes */
        while numberOfPages < totalPages {
            createPage()
            numberOfPages += 1
            spawnOutside()
        }
        while numberOfBoxes < 3 {
            createRandomBox()
            numberOfBoxes += 1
        }
        reflect.runAction(SKAction.fadeOutWithDuration(2))
    }
    
    func level2() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level2", ofType: "sks")
        let level2 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level2)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level2Background") as! SKSpriteNode
        reflect = childNodeWithName("//reflect") as! SKLabelNode
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        totalPages = 8
        numberOfPages = 0
        numberOfBoxes = 0
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        //        exit.position = CGPoint(x:622.22, y:435.624)
        
        /* Create pages and boxes */
        while numberOfPages < totalPages {
            createPage()
            numberOfPages += 1
            spawnOutside()
        }
        while numberOfBoxes < 3 {
            createRandomBox()
            numberOfBoxes += 1
        }
        
        spawnKiller()
        reflect.runAction(SKAction.fadeOutWithDuration(2))
    }
    
    func level3() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level3", ofType: "sks")
        let level3 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level3)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level3Background") as! SKSpriteNode
        bombTimer = childNodeWithName("//bombTimer") as! SKLabelNode
        reflect = childNodeWithName("//reflect") as! SKLabelNode
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        createBomb()
        bombTimer.moveToParent(bomb)
        bombTimer.position.x = 1.971
        bombTimer.position.y = -1.593
        
        totalPages = 8
        numberOfPages = 0
        numberOfBoxes = 0
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        //        exit.position = CGPoint(x:570.27, y:434.772)
        
        /* Create pages and boxes */
        while numberOfPages < totalPages {
            createPage()
            numberOfPages += 1
            spawnOutside()
        }
        while numberOfBoxes < 3 {
            createRandomBox()
            numberOfBoxes += 1
        }
        /* Calls function where the bomb counts down and leads to game over */
        destruction()
        spawnKiller()
        reflect.runAction(SKAction.fadeOutWithDuration(2))
    }
    
    func level4() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level4", ofType: "sks")
        let level4 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level4)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level4Background") as! SKSpriteNode
        bombTimer = childNodeWithName("//bombTimer") as! SKLabelNode
        reflect = childNodeWithName("//reflect") as! SKLabelNode
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        createBomb()
        bombTimer.moveToParent(bomb)
        bombTimer.position.x = 1.971
        bombTimer.position.y = -1.593
        
        totalPages = 6
        numberOfPages = 0
        numberOfBoxes = 0
        timeLeft = 31
        bombTime = 13
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        //        exit.position = CGPoint(x:107.258, y:189.524)
        
        /* Create pages and boxes */
        while numberOfPages < totalPages {
            createPage()
            numberOfPages += 1
            spawnOutside()
        }
        while numberOfBoxes < 3 {
            createRandomBox()
            numberOfBoxes += 1
        }
        /* Calls function where the bomb counts down and leads to game over */
        destruction()
        spawnKiller()
        reflect.runAction(SKAction.fadeOutWithDuration(2))
    }
    
    func level5() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level5", ofType: "sks")
        let level5 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
//        let lampFire2 = SKEmitterNode(fileNamed: "lampFire2")
        levelNode.addChild(level5)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        lighting2 = self.childNodeWithName("//lighting2") as! SKLightNode
        levelBackground = childNodeWithName("//level5Background") as! SKSpriteNode
        reflect = childNodeWithName("//reflect") as! SKLabelNode
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        totalPages = 13
        numberOfPages = 0
        timeLeft = 61
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        
        /* Create pages and boxes */
        while numberOfPages < totalPages {
            createPage()
            numberOfPages += 1
            createPhantomPage()
            numberOfPages += 1
        }
        
        /* Calls function where the bomb counts down and leads to game over */
        spawnKiller()
        spawnFire()
        fire2!.position = CGPoint(x: 342.5, y: 619.91)
        fire1!.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        reflect.runAction(SKAction.fadeOutWithDuration(2))
    }
    
    func level6() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level6", ofType: "sks")
        let level6 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level6)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        lighting2 = self.childNodeWithName("//lighting2") as! SKLightNode
        levelBackground = childNodeWithName("//level6Background") as! SKSpriteNode
        bombTimer = childNodeWithName("//bombTimer") as! SKLabelNode
//        reflect = childNodeWithName("//reflect") as! SKLabelNode
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        createBomb()
        bombTimer.moveToParent(bomb)
        bombTimer.position.x = 1.971
        bombTimer.position.y = -1.593
        
        totalPages = 10
        numberOfPages = 0
        timeLeft = 46
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        
        /* Create pages and boxes */
        while numberOfPages < totalPages {
            createPage()
            numberOfPages += 1
            createPhantomPage()
            numberOfPages += 1
        }
        
        /* Calls function where the bomb counts down and leads to game over */
        //        spawnKiller()
        spawnFire()
        destruction()
        spawnKiller()
        fire2!.position = CGPoint(x: 442.5, y: 319.91)
        fire1!.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
    }
    
    func comingSoon() {
        let resourcePath = NSBundle.mainBundle().pathForResource("ComingSoon", ofType: "sks")
        let comingSoon = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(comingSoon)
        let homeButton = childNodeWithName("//homeButton") as! MSButtonNode
        
        homeButton.selectedHandler = {
            
            /* Grab reference to Spritekit view */
            let skView = self.view as SKView!
            
            /* Load Main menu */
            let scene = MainMenu(fileNamed:"MainMenu") as MainMenu!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
    }
}
