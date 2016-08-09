//
//  GameManager.swift
//  Dark Diary
//
//  Created by Ulric Ye on 8/4/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import Foundation
import SpriteKit

/* Create GameManager to keep track of the current level outside so restart does
 not reset the currentlevel variable */
class GameManager {
    var currentlevel = 1
    var unlockedLevel: [Bool] = []
    var music: Bool = true
    static let sharedInstance = GameManager()
    
    init() {
        unlockedLevel.append(true)
        for _ in 1...4 {
            unlockedLevel.append(false)
        }
    }
}