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
    
    convenience init(layer: Int) {
        self.init()
        self.zLayer = layer * -100
        self.alpha = debugModeActive ? 1 : 0
        self.size = CGSize(width: 245, height: 70)
    }
    
    func sense(for intity: SKSpriteNode, from node: SKNode) {
        if self.contains(self.convert(intity.position, from: node)) {
            intity.zPosition = CGFloat(self.zLayer)
        }
    }
}

struct SceneDepthSensorStructure {
    var sensors = [Sensor]()
    
    mutating func buildSensors(to parent: SKNode, numberOfSensors: Int) {
        // There should be usually 29 sensors in Noble Sword.
        for sensorNumber in 1...numberOfSensors {
            sensors.append(Sensor(layer: sensorNumber))
        }
    }
    
    func sense(for intity: SKSpriteNode, from node: SKNode) {
        sensors.forEach { (sensor) in
            sensor.sense(for: intity, from: node)
        }
    }
}
