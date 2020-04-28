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
    enum Warp {
        case entry,exit
    }
    
    // MARK: - SceneConponents
    var currentState: State = .active
    var level: Level = Level()
    var changingSections: Bool = false
    
    /// A Space is an area in a section
    var currentSpace: Space = .two
    
    let moveJoystick = js(withDiameter: 100)
    
    var attackButton = SKSpriteNode()
    
    var joystickView = SKSpriteNode()
    
    var hero: Hero = Hero()
    var enemies: [Enemy] = []
    
    // Tests
    let s: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "Masa_R"), size: CGSize(width: 320, height: 320))
    var walkingStarted = false
    var lastDirection = ""
    var purpleEmitter: SKEmitterNode = SKEmitterNode()
    var trap: SKSpriteNode = SKSpriteNode()
    
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
    
    var minX: CGFloat = -90
    var maxX: CGFloat = 135
    var minY: CGFloat = -165
    var maxY: CGFloat = 207
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        if let node = camera?.childNode(withName: "AttackButton") as? SKSpriteNode {
            attackButton = node
        }
        
        if let node = camera?.childNode(withName: "jsNode") as? SKSpriteNode {
            joystickView = node
        }
        
        setUpSections()
        animateTraps()
        setupEnemy()
        setupPlayer()
        handleMovment(with: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
 
        if let currentSection = level.currentSection() {
                checkTriggers(section: currentSection)
        }
        followPlayer()
    }
    
    func followPlayer() {
        guard let section = level.currentSection() else {
            return
        }
        
        var canMoveMinX = true
        var canMoveMaxX = true
        var canMoveMinY = true
        var canMoveMaxY = true
        
        var canMoveX = false
        var canMoveY = false
        
        if camera?.position.x == minX {
            canMoveMinX = false
        }
        
        if (camera?.position.x == maxX) {
            canMoveMaxX = false
        }
        
        if camera?.position.y == minY {
            canMoveMinY = false
        }
        
        if (camera?.position.y == maxY) {
            canMoveMaxY = false
        }
        
        if ((canMoveMinX) && s.position.x > minX) && ((canMoveMaxX) && s.position.x < maxX) {
            canMoveX = true
        }
        
        if ((canMoveMinY) && s.position.y > minY) && ((canMoveMaxY) && s.position.y < maxY) {
            canMoveY = true
        }
        
        if (canMoveX && canMoveY) {
            camera?.run(.move(to: convert(self.s.position, to: section.mainNode), duration: 0.4))
        }
        else if canMoveX && !(canMoveY) {
            camera?.run(.moveTo(x: convert(self.s.position, to: section.mainNode).x, duration: 0.4))
        }
        else if !(canMoveX) && canMoveY {
            camera?.run(.moveTo(y: convert(self.s.position, to: section.mainNode).y, duration: 0.4))
        }
    }
    
    func setCameraPos() {
//        guard let section = level.currentSection() else {
//            return
//        }
//
//        camera?.run(.move(to: convert((section.camPosition?.getPos(space: currentSpace))!, from: section.mainNode), duration: 0.8))
    }
    
    func setUpSections() {
        var counter = 0

        children.forEach { node in
            if let name = node.name {
                if sectionInName(string: name) {
                    counter += 1
                }
            }
        }
        
        for n in 1...counter {
            setSection(number: n)
        }
    }
    
    func setSection(number: Int) {
        print("section\(number)")
        if let sectionNode = childNode(withName: "section\(number)") {
            var section = Section(mainNode: sectionNode, warps: [], sponPoints: [])
            
            if let trap1 = sectionNode.childNode(withName: "trap") as? SKSpriteNode {
                self.trap = trap1
            }
            
           let eArr = sectionNode.children.filter { (node) -> Bool in
                return (node.name == "enemy")
            }
            
            for e in eArr {
                if let sprite =  e as? SKSpriteNode {
                    enemies.append(Enemy(node: sprite))
                }
            }
            
            if let env = sectionNode.childNode(withName: "environment") {
                if let piller = env.childNode(withName: "piller") as? SKSpriteNode {
                    if let purple = piller.childNode(withName: "flame") as? SKEmitterNode {
                        
                        purpleEmitter = newEmitter(with: self, position: purple.position, file: "PurpleSpirite")
                        purpleEmitter.zPosition = 20
                        self.addChild(purpleEmitter)
                    }
                    
                }
            }
            
            if let node = sectionNode.childNode(withName: "space1") as? SKSpriteNode {
                section.spaces[.one] = node
            }
            if let node = sectionNode.childNode(withName: "space2") as? SKSpriteNode {
                section.spaces[.two] = node
            }
            if let node = sectionNode.childNode(withName: "space3") as? SKSpriteNode {
                section.spaces[.three] = node
            }
            if let warpOne = sectionNode.childNode(withName: "entry") as? SKSpriteNode  {
                section.entry = warpOne
            }
            if let warpOne = sectionNode.childNode(withName: "exit") as? SKSpriteNode  {
                section.exit = warpOne
            }
            if let sponPoint = sectionNode.childNode(withName: "sponPoint1") {
                section.sponOne = sponPoint.position
            }
            if let sponPoint = sectionNode.childNode(withName: "sponPoint2") {
                section.sponTwo = sponPoint.position
            }
            
            level.add(section: section)
        }
    }
    
    func sectionInName(string: String) -> Bool {
        for c in "section" {
            if !(string.contains(c)) {
                return false
            }
        }
        
        return true
    }
    
    func changeSections(warp: Warp) {
        if !changingSections {
            changingSections = true
            
            switch warp {
            case .entry:
                guard let section = level.previousSection() else {
                     return
                 }
                
                camera?.run(.move(to: section.mainNode.position, duration: 0.8)) {
                    let animMove: SKAction = .move(to: self.convert(section.sponTwo!, from: section.mainNode), duration: 0.8)
                    let animDown: SKAction = protectedAction(with: "walkU")
                    
                    self.s.run(animDown)
                    self.s.run(animMove) {
                        self.setCameraPos()
                        self.s.removeAllActions()
                        self.changingSections = false
                    }     
                }
            case .exit:
                guard let section = level.nextSection() else {
                    return
                }
                
                camera?.run(.move(to: section.mainNode.position, duration: 0.8)) {
                    let animMove: SKAction = .move(to: self.convert(section.sponOne!, from: section.mainNode), duration: 0.8)
                    let animDown: SKAction = protectedAction(with: "walkD")
                    
                    self.s.run(animDown)
                    self.s.run(animMove) {
                        self.setCameraPos()
                        self.s.removeAllActions()
                        self.changingSections = false
                    }
                }
            }
        }
    }

    func animateTraps() {
        let action = protectedAction(with: "normSpikeTrap")
        trap.run(action) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.animateTraps()
                
            }
        }
    }
    
    func checkTriggers(section: Section) {
        for (space, node) in section.spaces {
            if node.contains(convert(s.position, to: section.mainNode)) {
                self.currentSpace = space
            }
        }
        if let exit = section.exit {
            if !changingSections {
                if exit.contains(convert(s.position, to: section.mainNode)) {
                    self.changeSections(warp: .exit)
                }
            }
        }
        if let entry = section.entry {
            if !changingSections {
                if entry.contains(convert(s.position, to: section.mainNode)) {
                    self.changeSections(warp: .entry)
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
    
    // Mark: Enemy
    
    func setupEnemy() {
        for e in enemies {
            e.randomDirection()
            if let action = e.moveActionForCurrentDirection() {
                e.spriteNode.run(action)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if self.enemies.count != 0 {
                self.setupEnemy()
            }
        }
    }
    
    
    // MARK: Player setup
    
    func setupPlayer() {
            hero.configureAttributes()
            
        hero.player.zPosition = 5
        if let camera = self.childNode(withName: "camera") as? SKCameraNode {
            self.camera = camera
            setCameraPos()
            
            self.s.zPosition = 5
            self.addChild(self.s)
//            self.addChild(hero.player)
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if attackButton.contains(convert(pos, to: camera!)) {
            print("Attack!!!!")
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func handleMovment(with view: SKView) {
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: 7, y: 13, width: joystickView.size.width, height: joystickView.size.height))
        
        moveJoystickHiddenArea.joystick = moveJoystick
        moveJoystick.isMoveable = true
        moveJoystickHiddenArea.zPosition = 10
        moveJoystickHiddenArea.alpha = 0.001
        moveJoystickHiddenArea.position = CGPoint(x: -200, y: -350)
        
//        joystickView.addChild(moveJoystickHiddenArea)
        camera?.addChild(moveJoystickHiddenArea)
        
        //MARK: Handlers begin
        moveJoystick.on(.begin) { [unowned self] _ in }
        
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
                    // self.hero.player.position = CGPoint(x: self.hero.player.position.x + 2, y: self.hero.player.position.y)
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
