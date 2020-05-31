//
//  GameScene.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/5/20.
//  Copyright © 2020 EightFoldGamehero.player. All rights reserved.
//

import SpriteKit
import GameController

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

    var CM = ControlManager.shared
    let moveJoystick = js(withDiameter: 100)
    var joystickView = SKSpriteNode()
    
    var attackButton = SKSpriteNode()
    
    // Player Stuff
    var hero: Hero = Hero()
    typealias playerMovement = AnimationsReference.PlayerActions.Movement
    
    var attackCount: Int = 0
    
    var enemies: [Enemy] = []
    
    // Tests
//    let s: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "Masa_R"), size: CGSize(width: 320, height: 320))
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
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

//        setUpControllerObservers()
//        connectController()
        CM.delegate = self
        
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
        detectHits()
        
        if hero.hp <= 0 {
            print("game over")
        }
        
        if let currentSection = level.currentSection() {
                checkTriggers(section: currentSection)
        }
        
        followPlayer()
    }
    
    func detectHits() {
        // MARK: Enemy hits player
        for enemy in enemies {
            enemy.detectPlayer(player: hero.player)
            
            if enemy.currentState == .persuit {
                enemy.spriteNode.run(.move(to: self.hero.player.position, duration: 3))
            }
            else if !enemy.idleIndling, enemy.currentState == .idle {
                enemy.idleAnimation()
            }
            
            if let enemyAttBox = enemy.attBox {
                if hero.hitBox.contains(hero.hitBox.convert(enemyAttBox.position, from: enemy.spriteNode)) {
                    self.hero.hp -= 10
                    print("attacked")
                }
            }
            
            if enemy.hitBox.contains(enemy.hitBox.convert(hero.attHitBox.position, from: hero.player)) {
                if !enemy.takingDamage {
                    if self.hero.attackCount < 1 {
                        self.hero.attackCount += 1
                        enemy.takingDamage = true
                        enemy.hp -= 10
                        print("enemy hit")
                        enemy.takingDamage = false
                        if enemy.hp <= 0 {
                            enemies.removeAll(where: { $0.spriteNode == enemy.spriteNode })
                            enemy.spriteNode.removeFromParent()
                        }
                    }
                }
            }
        }
    }
    
    func followPlayer() {
        guard let section = level.currentSection() else {
            camera?.run(.move(to: self.hero.player.position, duration: 0.4))

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
        
        if ((canMoveMinX) && hero.player.position.x > minX) && ((canMoveMaxX) && hero.player.position.x < maxX) {
            canMoveX = true
        }
        
        if ((canMoveMinY) && hero.player.position.y > minY) && ((canMoveMaxY) && hero.player.position.y < maxY) {
            canMoveY = true
        }
        
        if (canMoveX && canMoveY) {
            camera?.run(.move(to: convert(self.hero.player.position, to: section.mainNode), duration: 0.4))
        }
        else if canMoveX && !(canMoveY) {
            camera?.run(.moveTo(x: convert(self.hero.player.position, to: section.mainNode).x, duration: 0.4))
        }
        else if !(canMoveX) && canMoveY {
            camera?.run(.moveTo(y: convert(self.hero.player.position, to: section.mainNode).y, duration: 0.4))
        }
    }
    
    func setCameraPos() {
//        guard let section = level.currentSection() else {
//            return
//        }
//
//        camera?.run(.move(to: convert((section.camPosition?.getPos(space: currentSpace))!, from: section.mainNode), duration: 0.8))
    }
    
    func masaAttack() {
        let attCollider = SKSpriteNode(color: .red, size: CGSize(width: 34.729, height: 46.733))

        hero.attHitBox = attCollider
        
        hero.player.run(protectedAction(with: "attackR")) {
            self.hero.player.removeAllActions()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.hero.player.addChild(attCollider)
            
            attCollider.position = CGPoint(x: 38.752, y: -1.896)
            attCollider.run(.moveTo(x: 85, duration: 0.3)) {
                attCollider.removeFromParent()
                self.attackCount -= 1
            }
        }
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


        if counter != 0 {
            for n in 1...counter {
                setSection(number: n)
            }
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
                    let enemy = Enemy(node: sprite)
                    enemies.append(enemy)
                    enemy.attack()
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
                    
                    self.hero.player.run(animDown)
                    self.hero.player.run(animMove) {
                        self.setCameraPos()
                        self.hero.player.removeAllActions()
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
                    
                    self.hero.player.run(animDown)
                    self.hero.player.run(animMove) {
                        self.setCameraPos()
                        self.hero.player.removeAllActions()
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
            if node.contains(convert(hero.player.position, to: section.mainNode)) {
                self.currentSpace = space
            }
        }
        if let exit = section.exit {
            if !changingSections {
                if exit.contains(convert(hero.player.position, to: section.mainNode)) {
                    self.changeSections(warp: .exit)
                }
            }
        }
        if let entry = section.entry {
            if !changingSections {
                if entry.contains(convert(hero.player.position, to: section.mainNode)) {
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
        for node in children {
            if (node.name == "enemy") {
                if let enemy = node as? SKSpriteNode {
                    enemies.append(Enemy(node: enemy))
                }
            }
        }
            
            
        

        
        
        for e in enemies {
            e.setUp()
            e.attack()
//            e.randomDirection()
//            if let action = e.moveActionForCurrentDirection() {
//                e.spriteNode.run(action)
//            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if self.enemies.count == 0 {
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
            
            self.hero.player.zPosition = 5
            self.addChild(self.hero.player)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if attackButton.contains(convert(pos, to: camera!)) {
            self.hero.attack()
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func handleMovment(with view: SKView) {
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rectOf: joystickView.size)//TLAnalogJoystickHiddenArea(rect: CGRect(x: 13, y: 7, width: joystickView.size.width, height: joystickView.size.height))
        
        moveJoystickHiddenArea.joystick = moveJoystick
        moveJoystick.isMoveable = true
        moveJoystickHiddenArea.zPosition = 10
        moveJoystickHiddenArea.alpha = 0.00001
        moveJoystickHiddenArea.position = CGPoint(x: -100, y: 0)
        
        camera?.addChild(moveJoystickHiddenArea)
        
        //MARK: Handlers begin
//        moveJoystick.on(.begin) { [unowned self] _ in }
        
        moveJoystick.on(.move) { [unowned self] joystick in
            let axies = self.chooseAxis(posx: joystick.velocity.x, posy: joystick.velocity.y)
            
            switch axies {
            case .x:
                if (joystick.velocity.x >= 1.0) {
                    self.moveRight()
                }
                else if (joystick.velocity.x <= -1.0) {
                    self.moveLeft()
                }
            case .y:
                if (joystick.velocity.y >= 1.0) {
                    self.moveUp()
                }
                else if (joystick.velocity.y <= -1.0) {
                    self.moveDown()
                }
            }
        }
        
        moveJoystick.on(.end) { [unowned self] _ in
            self.hero.player.removeAllActions()
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


extension GameSceneTemplate: ControllerDelegate {
    func moveUp() {
//        print("up")
        if self.hero.lastDirection != .upDirection  {
            self.walkingStarted = false
            self.hero.player.removeAllActions()
            
        }
        
        self.hero.lastDirection = .upDirection
        self.hero.player.position = CGPoint(x: self.hero.player.position.x, y: self.hero.player.position.y + 2)
        if !self.walkingStarted {
            self.walkingStarted = true
            
            DispatchQueue.main.async {
                self.hero.player.run(protectedAction(with: playerMovement.moveUp))
            }
        }
    }
    
    func moveDown() {
//        print("down")
        if self.hero.lastDirection != .downDirection {
            self.hero.player.removeAllActions()
            
            self.walkingStarted = false
        }
        
        self.hero.lastDirection = .downDirection
        self.hero.player.position = CGPoint(x: self.hero.player.position.x, y: self.hero.player.position.y - 2)
        if !self.walkingStarted {
            self.walkingStarted = true
            
            DispatchQueue.main.async {
                self.hero.player.run(protectedAction(with: playerMovement.moveDown))
            }
        }
    }
    
    func moveLeft() {
//        print("left")
        if self.hero.lastDirection != .leftDirection {
            self.walkingStarted = false
            self.hero.player.removeAllActions()
            
        }
        
        self.hero.lastDirection = .leftDirection
        self.hero.player.position = CGPoint(x: self.hero.player.position.x - 2, y: self.hero.player.position.y)
        if !self.walkingStarted {
            self.walkingStarted = true
            
            DispatchQueue.main.async {
                self.hero.player.run(protectedAction(with: playerMovement.moveLeft))
            }
        }
    }
    
    func moveRight() {
//        print("right")
        if self.hero.lastDirection != .rightDirection {
            self.walkingStarted = false
            self.hero.player.removeAllActions()
        }
        
        self.hero.lastDirection = .rightDirection
        self.hero.player.position = CGPoint(x: self.hero.player.position.x + 2, y: self.hero.player.position.y)
        
        if !self.walkingStarted {
            self.walkingStarted = true
            
            DispatchQueue.main.async {
                self.hero.player.run(protectedAction(with: playerMovement.moveRight))
            }
        }
    }
    
    func select() {
        
    }
    
    func cancel() {
        
    }
    
    func goUp(_ value: Float) {
        moveUp()
    }
    
    func goDown(_ value: Float) {
        moveDown()
    }
    
    func goRight(_ value: Float) {
        moveRight()
    }
    
    func goLeft(_ value: Float) {
        moveLeft()
    }
    
    func pause() {
        
    }
    
    func attack() {
        
    }
    
    func doNothing() {
        
    }
    
    open func setUpControllerObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(connectController), name: NSNotification.Name.GCControllerDidConnect , object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(controllersDisconnected), name: NSNotification.Name.GCControllerDidDisconnect , object: nil)
            
        }
        
        
        @objc open func connectController() {
            for controller in GCController.controllers() {
                
                if (controller.extendedGamepad != nil && controller.playerIndex == .indexUnset) {
                    controller.playerIndex = .index1
                    
                    
                    controller.extendedGamepad?.valueChangedHandler = nil
                    setUpExtendedController(controller: controller)
                }
//                else if (controller.gamepad != nil && controller.playerIndex == .indexUnset) {
//                    controller.playerIndex = .index1
//                    
//                    
//                    controller.gamepad?.valueChangedHandler = nil
//                    
//                }
                else if (controller.microGamepad != nil && controller.playerIndex == .indexUnset) {
                    controller.playerIndex = .index1
                    
                    controller.microGamepad?.valueChangedHandler = nil
                    setUpMicroController(controller: controller)
                    
                }
                
                
            }
            
            for controller in GCController.controllers() {
                if (controller.extendedGamepad != nil) {
                    // ignore extended
                }
//                else if (controller.gamepad != nil ) {
//                    // ignore standard
//
//                }
                else if (controller.microGamepad != nil && controller.playerIndex == .indexUnset) {
                    controller.playerIndex = .index1
                    
                }
                
            }
            
        }
    
    @objc func controllersDisconnected() {
        /*
        Options:
            - Do something when controller is is disconected
            - check what controllers are still connected if any
            - bring up headsUp display with option to reset controller
        */
    }
    
    func setUpExtendedController(controller: GCController) {
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad:GCExtendedGamepad, element: GCControllerElement) in
            
            // TODO: Multiplayer functionality
            //            if (gamepad.controller?.playerIndex == .index1) {
            //
            //
            //            }
            
            
            self.CM.gameplayMode(gamepad, nil, element)
        }
    }
    
    func setUpMicroController(controller: GCController) {
        controller.microGamepad?.valueChangedHandler = {
            (gamepad: GCMicroGamepad, element: GCControllerElement) in
            
            
            self.CM.gameplayMode(nil, gamepad, element)
        }
    }
}
