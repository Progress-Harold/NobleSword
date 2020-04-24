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
    var sectionDict: [Int: Section] = [Int: Section]()
    private var counter: Int = 0
    var currentSectionNumber: Int = 1
    
    mutating func add(section: Section) {
        counter += 1
        sections.append(section)
        sectionDict[counter] = section
    }
    
    mutating func previousSection() -> Section? {
        let index = currentSectionNumber - 1
        
        if (index) >= 1 {
            currentSectionNumber -= 1
            return sectionDict[index]
        }
        
        print("No previous section!")
        return nil
    }
    
    func currentSection() -> Section? {
        return sectionDict[currentSectionNumber]
    }
    
    mutating func nextSection() -> Section? {
        let index = currentSectionNumber + 1
        
        if (index <= sections.count) {
            currentSectionNumber += 1
            return sectionDict[index]
        }
        
        print("No next section!")
        return nil
    }
}
