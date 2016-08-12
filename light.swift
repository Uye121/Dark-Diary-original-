//
//  Light.swift
//  Dark Diary
//
//  Created by Ulric Ye on 7/11/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//


import SpriteKit

class Light: SKSpriteNode {
    var touchLocation: CGPoint!
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //detector = childNodeWithName("//detector") as! Light!
        for touch in touches {
            /* If the scene is not paused, enable light control */
            if !scene!.view!.paused {
                touchLocation = touch.locationInNode(self)
                light.light.position.x += touchLocation.x * 0.04
                light.light.position.y += touchLocation.y * 0.04
            }
        }
    }
    
    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        userInteractionEnabled = true
    }
    
}