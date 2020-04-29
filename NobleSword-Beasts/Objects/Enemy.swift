//
//  Enemy.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/25/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy {
    enum Direction {
        case left
        case right
        case up
        case down
        
        var image: SKTexture {
            var rawName: String = "EnemyKnight"
            
            switch self {
            case .left:
                rawName += "L"
            case .right:
                rawName += "R"
            case .up:
                rawName += "U"
            case .down:
                rawName += "D"
            }
            
            return SKTexture(imageNamed: rawName)
        }
    }
    
    var rawImageName: String = "EnemyKnight"
    var nodeName: String = "enemy"
    
    // MARK: Movement Variables
    var currentDircetion: Direction = .down
    var posibleDirections: [Direction] = [.left, .right, .down, .up]
    var currentPosition: CGPoint?
    var movementVar: Int = 100
    
    var spriteNode: SKSpriteNode = SKSpriteNode()
    
    // MARK: Enemy Hp
    var enemyHp: Int = 3
    
    init(node: SKSpriteNode) {
            self.spriteNode = node
            self.currentPosition = node.position
    }
    
    func moveActionForCurrentDirection() -> SKAction? {
        guard let currentPosition = currentPosition else {
            return nil
        }
        
        switch currentDircetion {
        case .left:
            return SKAction.moveTo(x: currentPosition.x - CGFloat(movementVar), duration: 0.5)
        case .right:
            return SKAction.moveTo(x: currentPosition.x + CGFloat(movementVar), duration: 0.5)
        case .up:
            return SKAction.moveTo(y: currentPosition.y + CGFloat(movementVar), duration: 0.5)
        case .down:
            return SKAction.moveTo(y: currentPosition.y - CGFloat(movementVar), duration: 0.5)
        }
    }
    
    func randomDirection() {
        let randomIndex = arc4random_uniform(UInt32(posibleDirections.count))
        
        currentDircetion = posibleDirections[Int(randomIndex)]
    }
}
