//
//  iAgent.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class iAgent : iMovableCharacter {
    
    var dead = false
    var dieing = false
    var levelCompleting = false
    
    override public func handleEvent(event: TouchEvent, sender: iLevel) {
        if(dead) {
            return
        }
        // ignore if already handling direction
        if(getDirectionFor(event: event) == self.direction) {
            return
        }
        self.previousDirection = direction
        if(event.type != TouchEvent.JUMP) {
            // move coordinate to normalized value
            switch previousDirection {
            case .Down:
                location.y = round(location.y)
                break
            case .Up:
                location.y = floor(location.y)
                break
            case .Left:
                location.x = floor(location.x)
                break
            case .Right:
                location.x = round(location.x)
                break
            default:
                break
            }
        }
        self.costume = "i"
        self.moving = true
        switch event.type {
        case TouchEvent.UP:
            // handle up
            direction = Direction.Up
            downOnNextChance = false
            jumping = false
            jumps = 0
            break
        case TouchEvent.DOWN:
            // handle down
            direction = Direction.Down
            upOnNextChance = false
            jumping = false
            jumps = 0
            self.costume = "j"
            break
        case TouchEvent.LEFT:
            downOnNextChance = false
            jumps = 0
            jumping = false
            upOnNextChance = false
            self.direction = Direction.Left
            break
        case TouchEvent.RIGHT:
            downOnNextChance = false
            jumps = 0
            jumping = false
            upOnNextChance = false
            self.direction = Direction.Right
            break
        case TouchEvent.JUMP:
            // do not allow jumping unless on a character
            let nextChar = level?.characterAt(x: location.x, y: location.y + 1)
            if(nextChar != nil && nextChar?.costume != " " && !jumping) {
                jumping = true
            }
            break
        case TouchEvent.STOP:
            direction = Direction.None
            moving = false
            downOnNextChance = false
            upOnNextChance = false
            jumping = false
            jumps = 0
            break
        default:
            break
        }
        requiresPaint = true
    }
    
    func getDirectionFor(event: TouchEvent) -> Direction {
        switch event.type {
        case TouchEvent.UP:
            return Direction.Up
        case TouchEvent.DOWN:
            return Direction.Down
        case TouchEvent.LEFT:
            return Direction.Left
        case TouchEvent.RIGHT:
            return Direction.Right
        default:
            return Direction.None
        }
    }
    
    override public func draw(rect: CGRect) {
        if(dieing) {
            die()
        }
        if(levelCompleting) {
            levelComplete()
        }
        super.draw(rect: rect)
    }
    
    override public func levelComplete() {
        // clear director
        let director = level?.characterAt(x: location.x, y: location.y)
        director?.costume = " "
        if(levelCompleting) {
            // sleep for a bit
            Thread.sleep(forTimeInterval: 0.05)
        }
        levelCompleting = true
        self.level?.repaint(lock: false)
        moving = false
        if(self.costume == "÷") {
            level?.session?.pause()
            level?.finished()
            dieing = false
        }
        self.costume = "÷"
    }
    
    override public func die() {
        if(dieing) {
            // sleep for a bit
            Thread.sleep(forTimeInterval: 0.05)
        }
        dieing = true
        dead = true
        moving = false
        level?.session?.updateLifeLabel()
        if(self.costume == "x") {
            level?.session?.lives -= 1
            if((level?.session?.lives)! <= 0) {
                level?.session?.endSession()
            } else {
                level?.reset()
            }
            dieing = false
        }
        self.costume = "x"
    }
    
}
