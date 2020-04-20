//
//  GameScene.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/5/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import SpriteKit

class GameSceneTemplate: SKScene {
    // MARK: Enums
    enum State {
        case cinematic,storyTelling,active,pause
    }
    enum Axies {
        case x,y
    }
    
    // MARK: - SceneConponents
    var currentState: State = .active
    var sections = [Int]()
    /// A Space is an area in a section
    var currentSpace: Space = .two
    
    var sectionOneAreas = [Space:SKSpriteNode]()
    var sectionTwoAreas = [Space:SKSpriteNode]()
    var sectionThreeAreas = [Space:SKSpriteNode]()
    var sectionOne: Section?
    
    let moveJoystick = js(withDiameter: 100)
    
    var hero: Hero = Hero()
    
    // Tests
    let s: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "Masa_R"), size: CGSize(width: 320, height: 320))
    var walkingStarted = false
    var lastDirection = ""
    var checkingPosition: Bool = false
    
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
        
        sectionOne = Section(camPosition: CameraPosition(one: CGPoint(x: -375, y: 0), two: CGPoint(x: 0, y: 0), three: CGPoint(x: 375, y: 0)), warps: [], sponPoints: [])

        // SetupSpaces
        if let section1 = childNode(withName: "section1") {
            if let node = section1.childNode(withName: "space1") as? SKSpriteNode {
                sectionOne?.spaces[.one] = node
            }
            if let node = section1.childNode(withName: "space2") as? SKSpriteNode {
                sectionOne?.spaces[.two] = node
            }
            if let node = section1.childNode(withName: "space3") as? SKSpriteNode {
                sectionOne?.spaces[.three] = node
            }
        }

        setupPlayer()
        handleMovment(with: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
 
        if let sectionOne = sectionOne {
            for (space, node) in sectionOne.spaces {
                if node.calculateAccumulatedFrame().contains(s.position) {
                    self.currentSpace = space
                    self.setCameraPos()
                }
            }            
        }
    }
    
    func chooseAxis(posx: CGFloat, posy: CGFloat) -> Axies {
        if (abs(posx) > abs(posy)) {
            return .x
        }
        else {
            return .y
        }
    }
    
    func setCameraPos() {
        camera?.run(.moveTo(x: sectionOne?.camPosition?.getPos(space: currentSpace).x ?? 0, duration: 0.8))
    }
    
    // MARK: Player setup
    
    func setupPlayer() {
            hero.configureAttributes()
            
        hero.player.zPosition = 10
        if let camera = self.childNode(withName: "camera") as? SKCameraNode {
            self.camera = camera
            setCameraPos()
            
            self.s.zPosition = 10
            self.addChild(self.s)
//            self.addChild(hero.player)
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func handleMovment(with view: SKView) {
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: 7, y: 13, width: 750, height: 1340))
        
        moveJoystickHiddenArea.joystick = moveJoystick
        moveJoystick.isMoveable = true
        moveJoystickHiddenArea.zPosition = 10
        moveJoystickHiddenArea.position = CGPoint(x: -320, y: -700)
        
        camera?.addChild(moveJoystickHiddenArea)
        
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
                        
                        DispatchQueue.main.async {
                            self.s.run(protectedAction(with: "walkR"))
                        }
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
                            self.s.run(protectedAction(with: "walkL"))
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
                    if !self.walkingStarted {
                        self.walkingStarted = true
                        
                        DispatchQueue.main.async {
                            self.s.run(protectedAction(with: "walkU"))
                        }
                    }
                }
                else if (joystick.velocity.y <= -1.0) {
                    print("down")
                    if self.lastDirection != "d" {
                        self.s.removeAllActions()
                        
                        self.walkingStarted = false
                    }
                    
                    self.lastDirection = "d"
                    self.s.position = CGPoint(x: self.s.position.x, y: self.s.position.y - 2)
                    if !self.walkingStarted {
                        self.walkingStarted = true
                        
                        DispatchQueue.main.async {
                            self.s.run(protectedAction(with: "walkD"))
                        }
                    }
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
