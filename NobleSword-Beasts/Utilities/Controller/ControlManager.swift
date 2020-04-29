//
//  ControlManager.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/28/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation
import GameController


/**
 This will delegate the act pressing button
 */
protocol ControllerDelegate {
    func select()
    func cancel()
    func goUp(_ value: Float)
    func goDown(_ value: Float)
    func goRight(_ value: Float)
    func goLeft(_ value: Float)
    func pause()
    func attack()
    func doNothing()
}


// you can do ext off delegates...




open class ControlManager {
    static var shared = ControlManager()
    var delegate: ControllerDelegate?
    
    var dPadPressed: Bool = false
    
    
    func dPadBuffer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dPadPressed = false
        }
    }
    
    func gameplayMode(_ extendedGamepad: GCExtendedGamepad?, _ microController: GCMicroGamepad?, _ element: GCControllerElement) {
        
            if let extendedGamepad = extendedGamepad {
//                print("gameplaymode called")
                if !dPadPressed {
                if (extendedGamepad.leftThumbstick == element) {
                    if (extendedGamepad.leftThumbstick.up.value) > 0.4 {
                        dPadPressed = true
                        dPadBuffer()
                        delegate?.goUp(extendedGamepad.leftThumbstick.up.value)
                        print("\(extendedGamepad.leftThumbstick.up.value)")
                    }
                    else if extendedGamepad.leftThumbstick.down.value > 0.4 {
                        dPadPressed = true
                        dPadBuffer()
                        delegate?.goDown(extendedGamepad.leftThumbstick.down.value)
                        print("\(extendedGamepad.leftThumbstick.down.value)")
                        
                    }
                    else if extendedGamepad.leftThumbstick.right.value > 0.4 {
                        dPadPressed = true
                        dPadBuffer()

                        delegate?.goRight(extendedGamepad.leftThumbstick.right.value)
                        print("\(extendedGamepad.leftThumbstick.right.value)")
                    }
                    else if extendedGamepad.leftThumbstick.left.value > 0.4 {
                        dPadPressed = true
                        dPadBuffer()

                        delegate?.goLeft(extendedGamepad.leftThumbstick.left.value)
                        print("\(extendedGamepad.leftThumbstick.left.value)")
                        
                    }
                }
                else if (extendedGamepad.dpad == element) {
                    if extendedGamepad.dpad.down.isPressed == true {
                        
                    }
                    else if extendedGamepad.dpad.up.isPressed == true {
                        
                    }
                    else if extendedGamepad.dpad.right.isPressed == true {
                        
                    }
                    else if extendedGamepad.dpad.left.isPressed == true {
                        
                    }
                }
                else if (extendedGamepad.buttonA == element) {
                    dPadPressed = true
                    dPadBuffer()

                    delegate?.select()
                }
                else if (extendedGamepad.buttonX == element) {
                    dPadPressed = true
                    dPadBuffer()

                    delegate?.attack()
                    
                }
                else if (extendedGamepad.buttonB == element) {
                    dPadPressed = true
                    dPadBuffer()

                    delegate?.cancel()
                }
                else if (extendedGamepad.buttonY == element) {
                    dPadPressed = true
                    dPadBuffer()

                    delegate?.pause()
                }
                else if (extendedGamepad.leftShoulder == element) {
                    
                }
                else if (extendedGamepad.leftTrigger == element) {
                    
                    
                }
                else if (extendedGamepad.rightShoulder == element) {
                    
                    
                }
                else if (extendedGamepad.rightTrigger == element) {
                    
                    
                }
            }
            
            if let microController = microController {
                if (microController.controller?.playerIndex == .index1) {
                    
                    
                    microController.reportsAbsoluteDpadValues = true
                    microController.allowsRotation = true
                    
                    
                    if (microController.dpad == element) {
                        if microController.dpad.down.value > 0.2 {
                            delegate?.goDown(microController.dpad.down.value)
                            print("thumbs down")
                            
                        }
                        else if microController.dpad.up.value > 0.2 {
                            delegate?.goUp(microController.dpad.up.value)
                            print("thumbs up")
                            
                        }
                        else if microController.dpad.right.value > 0.2 {
                            delegate?.goRight(microController.dpad.right.value)
                        }
                        else if microController.dpad.left.value > 0.2 {
                            delegate?.goLeft(microController.dpad.left.value)
                        }
                        else {
                            delegate?.doNothing()
                            
                        }
                    }
                    else if (microController.buttonA == element) {
                        // presshard on the remote touch pad
                        delegate?.select()
                        print("testing")
                    }
                    else if (microController.buttonX == element) {
                        // this is actually pause play
                        delegate?.attack()
                    }
                }
            }
                if extendedGamepad.leftThumbstick.left.isPressed == false,
                    extendedGamepad.leftThumbstick.down.isPressed == false,
                    extendedGamepad.leftThumbstick.right.isPressed == false,
                    extendedGamepad.leftThumbstick.left.isPressed == false  {
                    dPadPressed = false
                    // change to none later
                    delegate?.doNothing()
                    
                }
        }
    }
}
