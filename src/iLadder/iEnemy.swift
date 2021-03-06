//
//  iEnemy.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public extension Double {
    public static func random(lower: Double, upper: Double) -> Double {
        let r = Double(arc4random()) / Double(UInt32.max)
        return (r * (upper - lower)) + lower
    }
}

public class iEnemy : iMovableCharacter {
    
    var base : iEnemyBase?
    
    override public func update() {

        requiresPaint = true
        moving = true
        
        let randomNumber = Double.random(lower: Double(1), upper: Double(100))
        // make a random decision at each obstacle
        // currently everything but whitespace is
        // an obstacle
        // look underneath
        // ignore if on a ladder, only up or down
        // in that case
        if(direction != Direction.Left && direction != Direction.Right) {
            // go either left or right
            if(randomNumber < 50) {
                // go right
                direction = Direction.Right
                // randomly setup for ladder up/down
                if(randomNumber < 21) {
                    upOnNextChance = true
                } else {
                    downOnNextChance = true
                }
            } else {
                direction = Direction.Left
                // randomly setup for ladder up/down
                if(randomNumber > 73) {
                    upOnNextChance = true
                } else {
                    downOnNextChance = true
                }
            }
        }
        
        // look at next right or left
        // if end of the line go the other way
        if(location.x == 0) {
            direction = Direction.Right
        }
        if(location.x == level?.bounds.width) {
            direction = Direction.Left
        }
        
        // now allow supertype to move us
        super.update()
    }
    
    override public func die() {
        let index = level?.environment.characters.index(of: self as iMovableCharacter)
        if(index != nil) {
            level?.environment.characters.remove(at: index!)
        }
        base?.enemyRemoved()
    }
    
}
