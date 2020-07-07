//
//  DepthSensorStructure.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 6/7/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation
import SpriteKit

/**
Sensor is an SKSpriteNode that can sense if a given SKNode is within the bounds of the sensor.
 */
class Sensor: SKSpriteNode {
    /// Is the depth position of the sensor.
    var zLayer: Int = 0
    var debugModeActive: Bool {
        return Debugger.debugModeActive
    }
    
    var xPOS: Int = -10
    
    var calculatedYPosition: Int {
        let maxYPos: Int = 530
        if zLayer > 1 {
            let varient: Int = 100 * zLayer
            return (maxYPos - varient)
        }
        else {
            return maxYPos
        }
    }
    
    convenience init(layer: Int, xposition: Int? = nil) {
        self.init()
        self.zLayer = layer * -100
        self.alpha = 1//debugModeActive ? 1 : 0
        self.size = CGSize(width: 1500, height: 100)
        self.position = CGPoint(x: xposition ?? xPOS, y: calculatedYPosition)
        self.color = .cyan
    }
    
    func sense(for intity: SKSpriteNode, from node: SKNode) {
        if self.contains(self.convert(intity.position, from: node)) {
            intity.zPosition = CGFloat(self.zLayer)
        }
    }
}

struct SceneDepthSensorStructure {
    /// Parent node to all sensors.
    var mainNode: SKNode = SKNode()
    var sensors = [Sensor]()
    
    mutating func buildSensors(to parent: SKNode, numberOfSensors: Int) {
        // There should be usually 11 sensors in Noble Sword.
        for sensorNumber in 1...numberOfSensors {
            let sensor = Sensor(layer: sensorNumber)
            sensors.append(sensor)
            mainNode.addChild(sensor)
        }
        
        parent.addChild(mainNode)
    }
    
    func sense(for intity: SKSpriteNode, from node: SKNode) {
        sensors.forEach { (sensor) in
            sensor.sense(for: intity, from: node)
        }
    }
}
