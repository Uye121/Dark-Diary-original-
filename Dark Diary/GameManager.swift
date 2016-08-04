//
//  GameManager.swift
//  Dark Diary
//
//  Created by Ulric Ye on 8/4/16.
//  Copyright © 2016 TestingDummies@_@. All rights reserved.
//

import Foundation

//class GameManager {
//    static let sharedInstance = GameManager()
//    let defaults = NSUserDefaults.standardUserDefaults()
//    var currentlevel: Int = 1
//    var unlockedLevel1: [Bool] = NSUserDefaults.standardUserDefaults().boolForKey("unlockedLevel") ?? false {
//        didSet {
//            NSUserDefaults.standardUserDefaults().setObject(unlockedLevel, forKey:"unlockedLevel")
//            // Saves to disk immediately, otherwise it will save when it has time
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }
//    }
//    
//    func saveData(){
//        defaults.setObject(unlockedLevel1, forKey: "unlockedLevel")
//    }
//    
//    init (){
//        unlockedLevel1 = defaults.arrayForKey("unloackedLevel") as! [Bool]
//    }
//}