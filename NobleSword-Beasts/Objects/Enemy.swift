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
    
    enum State {
        case idle, patrol, persuit, attacking
    }
    
    var rawImageName: String = "EnemyKnight"
    var nodeName: String = "enemy"
    var currentState: State = .idle
    
    // MARK: Movement Variables
    var currentDircetion: Direction = .down
    var posibleDirections: [Direction] = [.left, .right, .down, .up]
    var currentPosition: CGPoint?
    var movementVar: Int = 100
    
    var spriteNode: SKSpriteNode = SKSpriteNode()
    var attBox: SKSpriteNode?
    
    // MARK: Senses
    var fieldOfView: SKSpriteNode = SKSpriteNode(color: .purple, size: CGSize(width: 400, height: 400))
    var strikingDistance: SKSpriteNode = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100))
    
    // MARK: Enemy Hp
    var hp: Int = 30
    var hitBox: SKSpriteNode = SKSpriteNode()
    
    var attacking: Bool = false
    var takingDamage: Bool = false
    var idleIndling: Bool = false

    
    init(node: SKSpriteNode) {
            self.spriteNode = node
            self.currentPosition = node.position
        self.idleAnimation()
    }
    
    func setUp() {

        fieldOfView.alpha = 0.5
        strikingDistance.alpha = 0.5
        spriteNode.addChild(fieldOfView)
        spriteNode.addChild(strikingDistance)
        
        hitBox = SKSpriteNode(color: .purple, size: CGSize(width: 50, height: 50))
        hitBox.alpha = 0.5
        
        self.spriteNode.addChild(hitBox)
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
    
    func attack() {
        if !attacking {
            attacking = true
            let attNode = SKSpriteNode(color: .red, size: CGSize(width: 60, height: 30))
            attBox = attNode
            attNode.alpha = 0.4
            attNode.zPosition = 10
            
            DispatchQueue.main.async {
                self.spriteNode.addChild(attNode)
                attNode.run(.moveTo(x: attNode.position.x + -60, duration: 1)) {
                    attNode.removeFromParent()
                    self.attBox = nil
                    self.attacking = false
                    self.attack()
                }
            }
        }
    }
    
    func idleAnimation() {
        if idleIndling != true {
            if currentState == .idle {
                idleIndling = true
                // animate moving left
                if (self.currentState != .idle) {
                    self.idleIndling = false
                    return }
                
                self.spriteNode.run(.moveTo(x: -100, duration: 0.9)) {
                    // animate moving right
                    if (self.currentState != .idle) {
                        self.idleIndling = false
                        return }
                    
                    self.spriteNode.run(.moveTo(x: 100, duration: 0.9)) {
                        // animate moving up
                        if (self.currentState != .idle) {
                            self.idleIndling = false
                        return
                        }
                        self.spriteNode.run(.moveTo(y: 100, duration: 0.9)) {
                            // animate moving down
                            if (self.currentState != .idle) {
                                self.idleIndling = false
                                return }
                            self.spriteNode.run(.moveTo(y: -100, duration: 0.9)) {
                                self.idleIndling = false
                                self.idleAnimation()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func detectPlayer(player: SKSpriteNode) {
        if fieldOfView.contains(spriteNode.convert(player.position, from: player.parent!)) {
            if currentState != .persuit {
                currentState = .persuit
                let action = protectedAction(with: "sfEnemy1RIdle")
                
                spriteNode.run(action)
                print("Player is within in sight")
            }
        }
        else if strikingDistance.contains(spriteNode.convert(player.position, from: player.parent!)) {
            currentState = .attacking
            print("Player is within striking distance")
        }
        else {
            currentState = .idle
        }
    }
    
    
    
    
    
    func randomDirection() {
        let randomIndex = arc4random_uniform(UInt32(posibleDirections.count))
        
        currentDircetion = posibleDirections[Int(randomIndex)]
    }
}
