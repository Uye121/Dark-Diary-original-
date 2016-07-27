//
//  level.swift
//  Dark Diary
//
//  Created by Ulric Ye on 7/22/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import SpriteKit

class Level: SKScene {
    var randomX = 0
    var randomY = 0
    var index = 0

    /* width and height of the screen */
    var levelWidth: CGFloat = 0.0
    var levelHeight: CGFloat = 0.0
//    var resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
    var levelBackground: SKSpriteNode!
    
    let level1 = SKSpriteNode (imageNamed: "//level1Background")

}

class Level1: Level {
    
    override func didMoveToView(view: SKView) {
//        levelBackground = childNodeWithName("//level1Background") as! SKSpriteNode
        

        levelWidth = level1.size.width
        levelHeight = level1.size.height
        
        index = 4
        
    }
    
}

