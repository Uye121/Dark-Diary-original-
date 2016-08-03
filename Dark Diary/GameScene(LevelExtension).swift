//
//  GameScene(LevelExtension).swift
//  Dark Diary
//
//  Created by Ulric Ye on 8/2/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    /////////////////////////////LEVELS/////////////////////////////
    func level1() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
        let level1 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level1)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level1Background") as! SKSpriteNode
        totalPages = 4
        numberOfPages = 0
        
        state = .Playing
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        /* create 4 pages for level 1 */
        while numberOfPages < totalPages {
            createPage()
            numberOfPages += 1
            spawnOutside()
        }
    }
    
    func level2() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level2", ofType: "sks")
        let level2 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level2)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level2Background") as! SKSpriteNode
        totalPages = 6
        numberOfPages = 0
        numberOfBoxes = 0
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
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
    }
    
    func level3() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level3", ofType: "sks")
        let level3 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level3)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level3Background") as! SKSpriteNode
        
        levelWidth = levelBackground.size.width
        levelHeight = levelBackground.size.height
        
        totalPages = 8
        numberOfPages = 0
        numberOfBoxes = 0
        
        light1.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        lightCamera.position = light1.position
        
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
    }
    
    func level4() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level4", ofType: "sks")
        let level4 = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(level4)
        lighting = self.childNodeWithName("//lighting") as! SKLightNode
        levelBackground = childNodeWithName("//level4Background") as! SKSpriteNode
        bombTimer = childNodeWithName("//bombTimer") as! SKLabelNode
        
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
    }
}