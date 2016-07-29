//
//  MSPhysicsNode.swift
//  Make School
//
//  Created by Martin Walsh on 15/03/2016.
//  Copyright © 2016 Martin Walsh. All rights reserved.
//

import SpriteKit

class MSReferenceNode: SKReferenceNode {
    
    /* Light node connection */
    var light: Light!
    
    override func didLoadReferenceNode(node: SKNode?) {
        
        /* Set reference to node */
        light = childNodeWithName("//light") as! Light
    }
}

class PageReferenceNode: SKReferenceNode {
    
    /* Page node connection */
    var page: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        
        /* Set reference to node */
        page = childNodeWithName("//page") as! SKSpriteNode
    }
}

class BoxReferenceNode: SKReferenceNode {
    var randomBox: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        randomBox = childNodeWithName("//randomBox") as! SKSpriteNode
    }
}

class BombReferenceNode: SKReferenceNode {
    var bomb: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        bomb = childNodeWithName("//bomb") as! SKSpriteNode
    }
}