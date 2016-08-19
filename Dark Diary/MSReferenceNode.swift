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

class KillerReferenceNode: SKReferenceNode {
    var killer: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        killer = childNodeWithName("//killer") as! SKSpriteNode
    }
}

class exitReferenceNode: SKReferenceNode {
    var exit: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        exit = childNodeWithName("//exit") as! SKSpriteNode
    }
}

class Fire1ReferenceNode: SKReferenceNode {
    var fire1: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        fire1 = childNodeWithName("//fire1") as! SKSpriteNode
    }
}

class Fire2ReferenceNode: SKReferenceNode {
    var fire2: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        fire2 = childNodeWithName("//fire2") as! SKSpriteNode
    }
}





