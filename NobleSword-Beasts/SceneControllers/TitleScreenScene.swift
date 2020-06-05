//
//  TitleScreenScene.swift
//  NobleSword
//
//  Created by ハローダヴィス on 7/1/18.
//  Copyright © 2018 ハローダヴィス. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVKit


class TitleScreenScene: SKScene {
    enum TitleScreenState {
        case credits
        case cutScene
        case skipAvailable
        case titleScreen
        case displayOptions
    }
    
    var currentState: TitleScreenState = .credits
    
    
    var avPlayer: AVPlayer?
    var videoNode: SKVideoNode?
    
    var skipTitleLabel: SKLabelNode?
    var skipButtonPresented: Bool = false
    
    var redEmitter: SKEmitterNode?
    var blueEmitter: SKEmitterNode?
    var greenEmitter: SKEmitterNode?
    var spE: SKEmitterNode?
    
    var title: SKSpriteNode?
    var tap: SKSpriteNode?
    var lighting: SKSpriteNode?
    var spirit: SKSpriteNode?
    
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
//        gameSC.sceneState = .titleScreen
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
//        if let camera = self.childNode(withName: "camera") as? SKCameraNode {
            
            
            self.currentState = .cutScene
            presentTitle()
//            if let skipBtn = camera.childNode(withName: "skip") as? SKLabelNode {
//                skipBtn.alpha = 0
//                self.skipTitleLabel = skipBtn
//                self.videoNode?.addChild(skipBtn)
//            }
//
//            if let videoPH = camera.childNode(withName: "movie") as? SKSpriteNode {
//                videoPH.alpha = 1
//
//                if let urlStr = Bundle.main.path(forResource: "Prelude", ofType: "mov") {
//                    let url = URL(fileURLWithPath: urlStr)
//
//                    self.avPlayer = AVPlayer(url: url)
//                    self.videoNode = SKVideoNode(avPlayer: self.avPlayer!)
//                    self.videoNode?.position = videoPH.position
//                    self.videoNode?.size = videoPH.size
//                    self.videoNode?.zPosition = 2
//                    self.addChild(self.videoNode!)
//                    self.videoNode!.play()
//                    videoPH.alpha = 0
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 36.7) {
//                        self.presentTitle()
//                    }
//                }
//            }
//        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = GameSceneTemplate(fileNamed: "SpiritForest") {
            
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.4))
        }
        
        if currentState == .cutScene,
            !skipButtonPresented {
            presentSkipBtn()
        }
        else if currentState == .cutScene,
            skipButtonPresented {
            presentTitle()
        }
        else if currentState == .titleScreen {
            currentState = .displayOptions
            
//            //
//            scene.scaleMode = .aspectFit
//            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.4))
            
        }
        else if currentState == .displayOptions {
//                scene.scaleMode = .aspectFit
//                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.4))
            }
            
//            if let scene = AwakeningScene(fileNamed: "AwakeningScene") {
//                scene.scaleMode = .aspectFit
//
//                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.4))
//            }
    }
    
    
    func presentSkipBtn() {
        skipTitleLabel?.run(.fadeIn(withDuration: 0.7))
        videoNode?.zPosition = 5
        skipTitleLabel?.zPosition = 20
        skipButtonPresented = true
    }
    
    
    func presentTitle() {
        currentState = .titleScreen
        skipTitleLabel?.removeFromParent()
        videoNode?.removeFromParent()
        
        let fireflies = newEmitter(with: self, position: CGPoint(x: 0, y: 0), file: "TitleFlies")
        fireflies.zPosition = -60
        self.camera?.addChild(fireflies)
//        
//        if let blue = self.camera?.childNode(withName: "blue") as? SKEmitterNode {
//            
//            blueEmitter = newEmitter(with: self, position: blue.position, file: "Blue")
//            
//            //            blueEmitter?.alpha = 0
//            
//            self.addChild(blueEmitter!)
//        }
//        if let red = self.camera?.childNode(withName: "red") as? SKEmitterNode {
//            
//            redEmitter = newEmitter(with: self, position: red.position, file: "Red")
//            
//            redEmitter?.alpha = 0
//            
//            self.addChild(redEmitter!)
//        }
//        
//        if let green = self.camera?.childNode(withName: "green") as? SKEmitterNode {
//            
//            greenEmitter = newEmitter(with: self, position: green.position, file: "Green")
//            
//            greenEmitter?.alpha = 0
//            
//            self.addChild(greenEmitter!)
//        }
        
        if let titleText = self.camera?.childNode(withName: "title") as? SKSpriteNode {
            
            title = titleText
            
            title?.alpha = 0
        }
//
//        if let tapText = self.camera?.childNode(withName: "tap") as? SKSpriteNode {
//            tap = tapText
//
//            tap?.alpha = 0
//        }
        
//        if let light = self.camera?.childNode(withName: "titleLight") as? SKSpriteNode {
//            lighting = light
//            lighting?.alpha = 0
//            lighting?.zPosition = 2
//        }
//
//        if let spiritLight = self.camera?.childNode(withName: "spirit") as? SKSpriteNode {
//            spirit = spiritLight
//            spirit?.alpha = 0
//
////            let oneRevolution:SKAction = SKAction.rotate(byAngle: 180, duration: 500)  //CGFloat.pi * 2
////            let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
//
////            self.spirit?.run(protectedAction(with: "CustomRotation"))
////            self.spirit?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//
//        }
//
//        if let spiritParticle = self.camera?.childNode(withName: "spE") as? SKEmitterNode {
//            spE = spiritParticle
//            spE?.alpha = 0
//        }
        
        
        UIView.animate(withDuration: 0.3) {
//            self.lighting?.alpha = 1
            self.title?.alpha = 1
            self.tap?.alpha = 1
            self.spirit?.alpha = 1
//            self.spE = newEmitter(with: self, position: (self.spE?.position)!, file: "Title")
//            self.spE?.alpha = 1
//            self.spE?.zPosition = -8
//            self.addChild(self.spE!)
            
            let flashNode = SKSpriteNode(color: .white, size: self.size)
            flashNode.alpha = 0
            self.videoNode?.addChild(flashNode)
            flashNode.alpha = 1
                
                self.videoNode?.removeFromParent()
            
            
            
        }
    }
    
    
    
    
}
