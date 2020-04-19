//
//  GameScene.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/5/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import SpriteKit

class GameSceneTemplate: SKScene {
    enum State {
        case cinematic,storyTelling,active,pause
    }
    enum Axies {
        case x,y
    }
    
    // MARK: - SceneConponents
    var currentState: State = .active
    var sections = [Int]()
    /// Section : Spon point
    var sponPoints = [Int:[CGPoint]]()
    let moveJoystick = js(withDiameter: 100)
    
    var hero: Hero = Hero()
    
    // Tests
    let s = SKSpriteNode(color: .blue, size: CGSize(width: 160, height: 160))
    var walkingStarted = false
    var lastDirection = ""
    
    var joystickStickImageEnabled = true {
        didSet {
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveJoystick.handleImage = image
        }
    }
    
    var joystickSubstrateImageEnabled = true {
        didSet {
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveJoystick.baseImage = image
        }
    }
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        setupPlayer()
        
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: 7, y: 13, width: 750, height: 1340))
        moveJoystickHiddenArea.joystick = moveJoystick
        moveJoystick.isMoveable = true
        moveJoystickHiddenArea.zPosition = 10
        self.camera?.addChild(moveJoystickHiddenArea)
        moveJoystickHiddenArea.position = CGPoint(x: -320, y: -700)

//        let rotateJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: frame.midY, y: 0, width: frame.midY, height: frame.width))
//        self.camera?.addChild(rotateJoystickHiddenArea)
        
        //MARK: Handlers begin
        moveJoystick.on(.begin) { [unowned self] _ in
            
        }
        
        moveJoystick.on(.move) { [unowned self] joystick in
            let axies = self.chooseAxis(posx: joystick.velocity.x, posy: joystick.velocity.y)
            
            switch axies {
            case .x:
                if (joystick.velocity.x >= 1.0) {
                    print("right")
                    if self.lastDirection != "r" {
                        self.walkingStarted = false
                        self.s.removeAllActions()
                    }
                    
                    self.lastDirection = "r"
                    self.s.position = CGPoint(x: self.s.position.x + 2, y: self.s.position.y)
                    if !self.walkingStarted {
                        self.walkingStarted = true
                    }
//                    self.hero.player.position = CGPoint(x: self.hero.player.position.x + 2, y: self.hero.player.position.y)
                }
                else if (joystick.velocity.x <= -1.0) {
                    print("left")
                    if self.lastDirection != "l" {
                        self.walkingStarted = false
                        self.s.removeAllActions()

                    }
                    
                    self.lastDirection = "l"
                    self.s.position = CGPoint(x: self.s.position.x - 2, y: self.s.position.y)
                    if !self.walkingStarted {
                        self.walkingStarted = true

                        DispatchQueue.main.async {
                            self.s.run(self.protectedAction(with: "walkL"))
                        }
                    }
                }
            case .y:
                if (joystick.velocity.y >= 1.0) {
                    print("up")
                    if self.lastDirection != "u" {
                        self.walkingStarted = false
                        self.s.removeAllActions()

                    }
                    
                    self.lastDirection = "u"
                    self.s.position = CGPoint(x: self.s.position.x, y: self.s.position.y + 2)
                    
                }
                else if (joystick.velocity.y <= -1.0) {
                    print("down")
                    if self.lastDirection != "d" {
                        self.s.removeAllActions()

                        self.walkingStarted = false
                    }
                    
                    self.lastDirection = "d"
                    self.s.position = CGPoint(x: self.s.position.x, y: self.s.position.y - 2)
                }
            }
        }
        
        moveJoystick.on(.end) { [unowned self] _ in
            self.s.removeAllActions()
            self.walkingStarted = false
        }
        
        
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        view.isMultipleTouchEnabled = true
    }
    
    func chooseAxis(posx: CGFloat, posy: CGFloat) -> Axies {
        if (abs(posx) > abs(posy)) {
            return .x
        }
        else {
            return .y
        }
    }
    
    // MARK: Player setup
    
    func setupPlayer() {
            hero.configureAttributes()
            
        hero.player.zPosition = 10
        if let camera = self.childNode(withName: "camera") as? SKCameraNode {
            self.camera = camera
            
            self.s.zPosition = 10
            self.camera?.addChild(self.s)
//            self.addChild(hero.player)
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    public func protectedAction(with name: String) -> SKAction {
        guard let action: SKAction = SKAction(named: name) else {
            return SKAction()
        }
        
        return action
    }
}


// MARK: - Touches

extension GameSceneTemplate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
