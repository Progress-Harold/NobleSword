//
//  Hero.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/6/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Hero {
    var direction: PlayerDirection?
    var startPoint: CGPoint?
    var state: PlayerState = .idle
    
    var lastDirection: PlayerDirection = .leftDirection
    
    var player: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "Masa_R_idle"))
    let attackReferenceNode = SKNode()
    
    var hitBox: SKSpriteNode = SKSpriteNode()
    var attHitBox: SKSpriteNode = SKSpriteNode()
    var hp: Int = 200
    
    var hasKey: Bool = false
    var attatcking: Bool = false
    var testAttatcksOn: Bool = true
    var walkingStarted = false
    
    var animCounter: Int = 0
    var attackCount: Int = 0
    var sp: Int = 10
    var spiritIsFull: Bool {
        return sp == 10
    }
    
    
    var xMove: CGFloat = 0
    var yMove: CGFloat = 0
    
    typealias playerActions = AnimationsReference.PlayerActions
    
    // MARK: - Player Configuration model
    enum PlayerDirection {
        case leftDirection
        case rightDirection
        case upDirection
        case downDirection
        
        var image: UIImage {
            switch self {
            case .leftDirection:
                return #imageLiteral(resourceName: "Masa_L_idle")
            case .rightDirection:
                return #imageLiteral(resourceName: "Masa_R_idle")
            case .upDirection:
                return #imageLiteral(resourceName: "Masa_U_idle")
            case .downDirection:
                return #imageLiteral(resourceName: "Masa_D_idle")
            }
        }
        
        var move: SKAction {
            var movement: SKAction = SKAction()
            
            switch self {
            case .leftDirection:
                movement = protectedAction(with: playerActions.Movement.moveLeft)
            case .rightDirection:
                movement = protectedAction(with: playerActions.Movement.moveRight)
            case .upDirection:
                movement = protectedAction(with: playerActions.Movement.moveUp)
            case .downDirection:
                movement = protectedAction(with: playerActions.Movement.moveDown)
            }
            return movement
        }
        
        var dash: SKAction {
            var movement: SKAction = SKAction()
            
            switch self {
            case .leftDirection:
                movement = protectedAction(with: playerActions.Movement.dashLeft)
            case .rightDirection:
                movement = protectedAction(with: playerActions.Movement.dashRight)
            case .upDirection:
                movement = protectedAction(with: playerActions.Movement.dashUp)
            case .downDirection:
                movement = protectedAction(with: playerActions.Movement.dashDown)
            }
            
            return movement
        }
    }
    
    enum PlayerState {
        case idle
        case attacking
        case kicking
        case dashing
    }
    
    enum AttackType {
        case sword
        case kick
        case spirit
        case spiritShield
    }
    
    func configureAttributes() {
        player.position = CGPoint(x: 0, y: 0)
        // Physics Body
        player.addChild(attackReferenceNode)
        
        let box = SKSpriteNode(color: .green, size: CGSize(width: 35, height: 60))
        box.position = CGPoint(x: 0, y: 20)
        box.zPosition = 30
        box.alpha = 0.2
        hitBox = box
        
        player.addChild(box)
        
        let colliderSize = CGSize(width: 34.246, height: 11.766)
        let collider = SKPhysicsBody(rectangleOf: colliderSize, center: CGPoint(x: 1.281, y: -32.273))
        
        player.physicsBody = collider
        player.physicsBody?.restitution = 0
        player.physicsBody?.linearDamping = 0.1
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.mass = 0.1
        player.physicsBody?.isDynamic = true
        
    }
    
    
    func doNothing() {
        let currentTexture = SKTexture(image: self.lastDirection.image)
        player.removeAllActions()
        player.texture = currentTexture
        player.alpha = 1
    }
    
    
    func change(state: MoveState) {
        player.texture = SKTexture(image: self.lastDirection.image)
        
        switch state {
        case .n:
            self.lastDirection = .upDirection
            DispatchQueue.main.async {
                self.player.run(self.lastDirection.move)
            }
        case .s:
            self.lastDirection = .downDirection
            DispatchQueue.main.async {
                self.player.run(self.lastDirection.move)
            }
        case .e:
            self.lastDirection = .rightDirection
            DispatchQueue.main.async {
                self.player.run(self.lastDirection.move)
            }
        case .w:
            self.lastDirection = .leftDirection
            DispatchQueue.main.async {
                self.player.run(self.lastDirection.move)
            }
        }
    }
    
    
    func dash() {
        let seq = SKAction.sequence([self.lastDirection.dash])
        let group = SKAction.group([seq])
        let action = SKAction.repeat(group, count: 1)
        // dash based on direction
        
        self.player.run(action)
        self.state = .dashing

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state = .idle
        }
    }
    
    
    func attack() {
        testAttatcksOn = false
        if !testAttatcksOn {
            attackReferenceNode.removeAllChildren()
            let attackNode = SKNode()
            
            let yAxis = 3.66
            let xAxis = -1.896
            
            var colliderSize = CGSize(width: 34.729, height: 46.733)
            var action: SKAction = SKAction()
            var attackCollider = SKPhysicsBody()
            var moveTo = CGFloat()
            
            switch lastDirection {
            case .leftDirection:
                attackCollider = SKPhysicsBody(rectangleOf: colliderSize, center: CGPoint(x: -34.662, y: yAxis))
                moveTo = -41.662
                action = protectedAction(with: playerActions.Attacks.attackLeft)
            case .rightDirection:
                let attCollider = SKSpriteNode(color: .red, size: CGSize(width: 34.729, height: 46.733))

                attHitBox = attCollider
                
                player.run(protectedAction(with: "attackR")) {
                    self.player.removeAllActions()
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.player.addChild(attCollider)
                    
                    attCollider.position = CGPoint(x: 38.752, y: -1.896)
                    attCollider.run(.moveTo(x: 85, duration: 0.3)) {
                        attCollider.removeFromParent()
                        self.attackCount -= 1
                    }
                }
//                let attCollider = SKSpriteNode(color: .red, size: colliderSize)
//
//                attCollider.position = CGPoint(x: 38.752, y: yAxis)
//                moveTo = 45.752
//                action = protectedAction(with: playerActions.Attacks.attackRight)
            case .upDirection:
                colliderSize = CGSize(width: 46.733, height: 34.729)
                attackCollider = SKPhysicsBody(rectangleOf: colliderSize, center: CGPoint(x: xAxis, y: 53.728))
                moveTo = 60.728
                action = protectedAction(with: playerActions.Attacks.attackUp)
            case .downDirection:
                colliderSize = CGSize(width: 46.733, height: 34.729)
                attackCollider = SKPhysicsBody(rectangleOf: colliderSize, center: CGPoint(x: xAxis, y: -50.778))
                moveTo = -57.778
                action = protectedAction(with: playerActions.Attacks.attackDown)
            }
            
//            basicCollider(for: attackCollider)
//            attackNode.physicsBody = attackCollider
//            attackReferenceNode.addChild(attackNode)
//            player.run(action)
//            if lastDirection == .leftDirection || lastDirection == .rightDirection {
//                attackNode.run(.moveTo(x: moveTo, duration: 0.2)) {
//                    attackNode.removeFromParent()
//                }
//            }
//            else {
//                attackNode.run(.moveTo(y: moveTo, duration: 0.2)) {
//                    attackNode.removeFromParent()
//                }
//            }
        }
//        else {
//            var texture: SKTexture = SKTexture()
//
//            // Testing attatcks
//            switch lastDirection {
//            case .leftDirection:
//                texture = SKTexture(image: #imageLiteral(resourceName: "PlayerTestL"))
//            case .rightDirection:
//                texture = SKTexture(image: #imageLiteral(resourceName: "PlayerTestR"))
//            default:
//                texture = SKTexture(image: #imageLiteral(resourceName: "PlayerTestR"))
//            }
//
//            let action = SKAction.animate(with: [texture, SKTexture(image: lastDirection.image)], timePerFrame: 0.1, resize: true, restore: true)
//
//            let loop = SKAction.repeat(action, count: 1)
////            let seq = SKAction.sequence([action])
//            basicAttack()
//            player.run(loop)
//        }
    }
    
    
    @objc func basicAttack() {
        // create invisible attack sprite (red in debug mode)
        /*
         Size:
         w: 97.459
         h: 184.199
         
         
         Starting:
         x: 77.445
         y: 39.35
         
         Ending:
         x: 107.946
         y: 27.9
         */
        var attackNode: SKSpriteNode
        var attPosition: CGPoint
        
        switch lastDirection {
        case .rightDirection:
            attackNode = SKSpriteNode(color: .cyan, size: CGSize(width: 97.459, height: 184.199))
            attackNode.alpha = 0.2
            // set starting position
            attackNode.position = CGPoint(x: 77.445, y: 39.35)
            
            attPosition = CGPoint(x: 107.946, y: 27.9)
            self.player.addChild(attackNode)
            let action = SKAction.move(to: attPosition, duration: 0.5)
            let seq = SKAction.repeatForever(action)
            
            attackNode.run(seq)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                attackNode.removeFromParent()
            }
        default:
            break
        }
        
        
        
        
        // call animation
        // move attack sprite
        //
        
    }
    
    
    func spiritAttack() {
        // Add Actions
        // TODO: Add SWScale
        // add collision object
        // TODO: Add SpritWave
        
        DispatchQueue.main.async {
            if !self.attatcking {
//                self.attackReferenceNode.addChild(self.attackColider)
                self.attatcking = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    if self.attatcking {
//                        self.attackColider.removeFromParent()
                        self.attatcking = false
                    }
                }
//                self.attackColider.configure(size: CGSize(width: 100, height: 100), collidableObjects: [CollisionsCategoryReference.enemy])
                
//                self.attackColider.run(protectedAction(with: "SWScale"))
                var animation: [SKTexture] = []
                
                for i in 1...17 {
                    if i > 9 {
                        animation.append(SKTexture(imageNamed: "MASA_Right_SpiritWave \(i)"))
                    }
                    else {
                        animation.append(SKTexture(imageNamed: "MASA_Right_SpiritWave 0\(i)"))
                    }
                }
                
//                self.player.perform(<#T##aSelector: Selector##Selector#>, on: <#T##Thread#>, with: <#T##Any?#>, waitUntilDone: <#T##Bool#>)
                self.player.run(SKAction.animate(with: animation, timePerFrame: 0.1, resize: true, restore: true)) { //protectedAction(with: "SpiritAttack")) {
                    self.attatcking = false
//                    self.attackColider.removeFromParent()
                }
            }
            else {
//                self.attackColider.removeFromParent()
                self.attatcking = false
            }
            
        }
    }
    
    
//    func collect(item: Item) {
//        switch item {
//        case .key:
//            hasKey = true
//            itemPack.keys += 1
//        case .dragonStone:
//            if !itemPack.dragonStones.statueIsComplete {
//                itemPack.dragonStones.collectedPieces += 1
//            }
//        case .spiritOrb:
//            if itemPack.spiritOrbs != 10 {
//                itemPack.spiritOrbs += 1
//            }
//        }
//        // increment
//    }
//
//
//    func use(item: Item) {
//        // decrement
//    }
}
