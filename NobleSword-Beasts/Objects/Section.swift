//
//  Section.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/19/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation
import SpriteKit

struct Section {
    var mainNode: SKNode
    
    var warps: [SKSpriteNode]
    var exit: SKNode?
    var entry: SKNode?
    
    var sponPoints: [CGPoint]
    var sponOne: CGPoint?
    var sponTwo: CGPoint?
}
