//
//  SceneDepthSensorTests.swift
//  NobleSword-BeastsTests
//
//  Created by Lee Davis on 4/5/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import XCTest
import SpriteKit
@testable import NobleSword_Beasts

class SceneDepthSensorTests: XCTestCase {

    var numberOfSensors: Int = 0
    var depthSensingStruct: SceneDepthSensorStructure?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.depthSensingStruct = SceneDepthSensorStructure()
        self.numberOfSensors = 29
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.depthSensingStruct = nil
        self.numberOfSensors = 0
    }

    func testBuildingAStructure() {
        buildTestStructure()
        
        XCTAssertTrue((depthSensingStruct?.sensors.count == numberOfSensors))
        
        depthSensingStruct?.sensors.removeAll()
    }

    func testNoneBuiltStructures() {
        XCTAssertNotNil(depthSensingStruct)

        XCTAssertTrue(depthSensingStruct!.sensors.isEmpty)
    }
    
    func testBuiltStructures() {
        buildTestStructure()
        
        XCTAssertTrue(!depthSensingStruct!.sensors.isEmpty)
    }
    
    func buildTestStructure() {
        // Check if the depthSensingStruct
        XCTAssertNotNil(depthSensingStruct)
        
        depthSensingStruct?.buildSensors(to: SKNode(), numberOfSensors: numberOfSensors)
    }
}
