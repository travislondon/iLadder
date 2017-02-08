//
//  Character.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class iLadderCharacter : iPaintable {
    
    var costume = Character("ß")
    var location = CGPoint(x: 0, y: 0)
    var fontAttributes : [String: UIFont]!
    var requiresPaint = true
    var level : iLevel?
    
    init(costume : Character, level : iLevel) {
        self.costume = costume
        self.level = level
    }
    
    public func setX(x: CGFloat) {
        location.x = x
        requiresPaint = true
    }
    
    public func setY(y: CGFloat) {
        location.y = y
        requiresPaint = true
    }
    
    public func getCostume() -> Character {
        return costume
    }
    
    public func update() {
        // let subtypes override
    }
    
    public func draw(rect: CGRect) {
        // paint self
        if(self is iScoreBoost) {
            print("Found score boost")
        }
        let string = NSString.init(string: String(costume))
        string.draw(at: CGPoint(x: CGFloat(location.x) * (level?.letterWidth)!, y: CGFloat(location.y) * (level?.letterHeight)!), withAttributes: level?.fontAttributes)
    }
    
    public func handleEvent(event: TouchEvent, sender: iLevel) {
        // let subtypes override
    }
    
    public static func ==(lhs: iLadderCharacter, rhs: iLadderCharacter) -> Bool {
        return lhs.location.x == rhs.location.x && lhs.location.y == rhs.location.y && lhs.costume == rhs.costume
    }
    
    public static func !=(lhs: iLadderCharacter, rhs: iLadderCharacter) -> Bool {
        return !(lhs == rhs)
    }
}
