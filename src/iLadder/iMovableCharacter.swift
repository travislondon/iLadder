//
//  iMovableCharacter.swift
//  iLadder
//
//  Created by Travis London on 1/28/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class iMovableCharacter : iInteractiveCharacter, Hashable {
    var moving = false
    var jumping = false
    var jumps = 0
    var direction = Direction.None
    var upOnNextChance = false
    var downOnNextChance = false
    var removed = false
    var previousLocation = CGPoint(x:0, y:0)
    var previousDirection = Direction.None
    static var lastId = 0
    var id = 0
    
    override init(costume: Character, level: iLevel) {
        super.init(costume: costume, level: level)
        id = iMovableCharacter.lastId + 1
        iMovableCharacter.lastId = id
    }
    
    override public func update() {
        previousLocation = CGPoint(x: round(location.x), y: round(location.y))
        if(moving) {
            switch direction {
            case .Up:
                location.y -= CGFloat(1)
                break
            case .Down:
                location.y += CGFloat(1)
                break
            case .Left:
                location.x -= CGFloat(1)
                break
            case .Right:
                location.x += CGFloat(1)
                break
            case .None:
                moving = false
                return
            }
        }

        // if in jump mode adjust height
        if(jumping) {
            if(jumps < 4) {
                if(jumps < 2) {
                    location.y -= CGFloat(1)
                }
                jumps += 1
                moving = true
            } else {
                jumps = 0
                jumping = false
            }
        }
    }
    
    public static func ==(lhs: iMovableCharacter, rhs: iMovableCharacter) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var hashValue: Int { return self.id * 31 }
}
