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
    
    /* Light node connection */
    var page: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        
        /* Set reference to node */
        page = childNodeWithName("//page") as! SKSpriteNode
    }
}