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
            static var moveLeft: String = "walkL"
            static var moveRight: String = "walkR"
            static var moveUp: String = "walkU"
            static var moveDown: String = "walkD"
            
            // Dashing
            static var dashLeft: String = "dashL"
            static var dashRight: String = "dashR"
            static var dashUp: String = "dashU"
            static var dashDown: String = "dashD"
        }
        
        struct Attacks {
            static var attackLeft: String = "attackL"
            static var attackRight: String = "attackR"
            static var attackUp: String = "attackU"
            static var attackDown: String = "attackD"
        }
    }
    
    struct SpiritForest {
        struct Enemies {
            static var attackL: String = "attackLE"
            static var attackR: String = "attackRE"
            static var attackU: String = "attackUE"
            static var attackD: String = "attackDE"
        }
    }
}
