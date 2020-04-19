//
//  AnimationsReference.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/6/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation


public class AnimationsReference {
    struct PlayerActions {
        struct Movement {
            static var moveLeft: String = "moveLeft"
            static var moveUpperLeft: String = "moveUpperLeft"
            static var moveLowerLeft: String = "moveLowerLeft"
            
            
            static var moveRight: String = "moveRight"
            static var moveUpperRight: String = "moveUpperRight"
            static var moveLowerRight: String = "moveUpperRight"
            
            
            static var moveUp: String = "moveUp"
            static var moveDown: String = "moveDown"
            
            // Dashing
            static var dashLeft: String = "dashLeft"
            static var dashRight: String = "dashRight"
            static var dashUp: String = "dashUp"
            static var dashDown: String = "dashDown"
        }
        
        struct Attacks {
            static var attackLeft: String = "attackLeft"
            static var attackRight: String = "attackRight"
            static var attackUp: String = "attackUp"
            static var attackDown: String = "attackDown"
        }
    }
    
    struct SpiritForest {
        struct Enemies {
            static var attackL: String = "AttackL"
            static var attackR: String = "AttackR"
            static var uAttackL: String = "UAttackL"
            static var uAttackR: String = "UAttackR"
        }
    }
}
