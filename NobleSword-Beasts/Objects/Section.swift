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
    var spaces = [Space: SKSpriteNode]()
    var camPosition: CameraPosition? = CameraPosition(one: CGPoint(x: -375, y: 0), two: CGPoint(x: 0, y: 0), three: CGPoint(x: 375, y: 0))
    
    var warps: [SKSpriteNode]
    var exit: SKNode?
    var entry: SKNode?
    
    var sponPoints: [CGPoint]
    var sponOne: CGPoint?
    var sponTwo: CGPoint?
}

struct CameraPosition {
    var one: CGPoint
    var two: CGPoint
    var three: CGPoint
    
    func getPos(space: Space) -> CGPoint {
        switch space {
        case .one:
            return one
        case .two:
            return two
        case .three:
            return three
        }
    }
}

enum Space {
    case one, two, three
}
