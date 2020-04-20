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
    var spaces = [Space:SKSpriteNode]()
    var camPosition: CameraPosition?
    var warps: [SKSpriteNode]
    var sponPoints: [CGPoint]
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
