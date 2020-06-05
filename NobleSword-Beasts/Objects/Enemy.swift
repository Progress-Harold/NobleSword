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

        fieldOfView.alpha = 0
        strikingDistance.alpha = 0
        spriteNode.addChild(fieldOfView)
        spriteNode.addChild(strikingDistance)
        
        hitBox = SKSpriteNode(color: .purple, size: CGSize(width: 50, height: 50))
        hitBox.alpha = 0
        
        self.spriteNode.addChild(hitBox)
        
        //Attack Node
        let attNode = SKSpriteNode(color: .red, size: CGSize(width: 60, height: 52))
        attNode.position = CGPoint(x: 40, y: -30)
        attBox = attNode
        attNode.alpha = 0
        attNode.zPosition = 10
        self.spriteNode.addChild(attNode)
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
//        let attNode = SKSpriteNode(color: .red, size: CGSize(width: 60, height: 52))
//        attNode.position = CGPoint(x: 40, y: -30)
//        attBox = attNode
//        attNode.alpha = 0.4
//        attNode.zPosition = 10
//        self.spriteNode.addChild(attNode)
    }
    
    func idleAnimation() {
        if idleIndling != true {
            if currentState == .idle {
                idleIndling = true
                if (self.currentState != .idle) {
                    self.idleIndling = false
                    return }
                
                runAnimation(direction: .left)
                self.spriteNode.run(.moveTo(x: -100, duration: 1.5)) {
                    // animate moving left
                    if (self.currentState != .idle) {
                        self.idleIndling = false
                        return }
                    
                    self.runAnimation(direction: .right)
                    self.spriteNode.run(.moveTo(x: 100, duration: 1.5)) {
                        // animate moving right
                        if (self.currentState != .idle) {
                            self.idleIndling = false
                        return
                        }
                        self.idleIndling = false
                        self.idleAnimation()
                    }
                }
            }
        }
    }

    func detectPlayer(player: SKSpriteNode) {
        let direction: Direction = calculateDirection(player: player)
        
        if fieldOfView.contains(spriteNode.convert(player.position, from: player.parent!)) {
            if currentState != .persuit {
                currentState = .persuit
                self.runAnimation(direction: direction)
                print("Player is within in sight")
            }
            
            if currentDircetion != direction {
                currentDircetion = direction
                self.runAnimation(direction: direction)
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
    
    func runAnimation(direction: Direction) {
        let action: SKAction = (direction == .right) ? protectedAction(with: "sfEnemy1RIdle") : protectedAction(with: "sfEnemy1LIdle")
        
        self.attBox?.position = (direction == .left) ? CGPoint(x: -35, y: -30) : CGPoint(x: 40, y: -30)
        DispatchQueue.main.async {
            self.spriteNode.run(action)
        }
    }
    
    func calculateDirection(player: SKSpriteNode) -> Direction {
        if let parent = spriteNode.parent, let playerParent = player.parent {
            if parent.convert(player.position, from: playerParent).x < spriteNode.position.x {
                return .left
            }
        }
        
        
        return .right
    }
    
    
    
    func randomDirection() {
        let randomIndex = arc4random_uniform(UInt32(posibleDirections.count))
        
        currentDircetion = posibleDirections[Int(randomIndex)]
    }
}


