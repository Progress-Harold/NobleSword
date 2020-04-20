//
//  Level.swift
//  NobleSword-Beasts
//
//  Created by Lee Davis on 4/19/20.
//  Copyright © 2020 EightFoldGames. All rights reserved.
//

import Foundation
import SpriteKit

struct Level {
    private var sections: [Section] = [Section]()
    private var sectionDict: [Int: Section] = [Int: Section]()
    private var counter: Int = 0
    private var currentSectionNumber: Int = 0
    
    mutating func add(section: Section) {
        counter += 1
        sections.append(section)
        sectionDict[counter - 1] = section
    }
    
    func getPreviousSection() -> Section? {
        let index = currentSectionNumber - 2
        
        if (index) >= 0 {
            return sectionDict[index]
        }
        
        print("No previous section!")
        return nil
    }
    
    func getNextSection() -> Section? {
        let index = currentSectionNumber + 2
        
        if (index <= sections.count) {
            return sectionDict[index]
        }
        
        print("No next section!")
        return nil
    }
    
}
