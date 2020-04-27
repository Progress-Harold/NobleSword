//
//  Tools.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/6/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation
import SpriteKit

typealias Function = ()

enum MoveState {
    case n,s,w,e
}

public func protectedAction(with name: String, duration: TimeInterval? = nil) -> SKAction {
    if (duration != nil) {
        guard let action: SKAction = SKAction(named: name, duration: duration!) else {
            return SKAction()
        }
        
        return action
    }
    guard let action: SKAction = SKAction(named: name) else {
        return SKAction()
    }
    
    return action
}

func newEmitter(with scene: SKScene, position: CGPoint, file: String) -> SKEmitterNode {
    guard let emitter = SKEmitterNode(fileNamed: file) else {
        print("fail")
        return SKEmitterNode(fileNamed: "LifeGauge")!
    }
    
    emitter.position = position
    emitter.xScale = 1
    emitter.yScale = 1
    
    emitter.targetNode = scene
    emitter.alpha = 0
    
    return emitter
}

public func basicCollider(for physicsBody: SKPhysicsBody) {
    physicsBody.restitution = 0
    physicsBody.linearDamping = 0.1
    physicsBody.allowsRotation = false
    physicsBody.affectedByGravity = false
    physicsBody.mass = 0.1
    physicsBody.isDynamic = true
    physicsBody.pinned = true
}


extension UIColor {
    func pink() -> UIColor {
        return UIColor(red: 204, green: 115, blue: 225, alpha: 1)
    }
}


/// Location
struct Point {
    var x: Int
    var y: Int
}


/// LocationType
enum LocationType {
    case x
    case y
    
    func checkNegativity(cgPoint: CGFloat) {
        // get direction
    }
}

public func buildTextureArr(with baseName: String, numberOfTextures: Int) -> [SKTexture] {
    var textures: [SKTexture] = []
    let counter = 1
    if counter < numberOfTextures && counter < 10 {
        if let image = UIImage(named: "\(baseName) 0\(counter)") {
            textures.append(SKTexture(image: image))
        }
    } else {
        if let image = UIImage(named: "\(baseName) \(counter)") {
            textures.append(SKTexture(image: image))
        }
    }
    return textures
}



public class Buffer {
    var isActive: Bool = false
    
    func activate(with timer: Double) {
        isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timer) {
            self.deactivate()
        }
    }
    
    
    func deactivate() {
        isActive = false
    }
}
