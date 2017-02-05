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

    override public func levelComplete() {
        let chars = [" ", "o", "O", "0", "o", "O", "0","o", "O", "0","o", "O", "0"]
        for char in chars {
            self.costume = Character(char)
            self.level?.repaint(lock: false)
            usleep(100000)
        }
        level?.finished()
    }
    
    override public func die() {
        dead = true
        moving = false
        level?.session?.lives -= 1
        level?.session?.updateLifeLabel()
        let chars = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "x"]
        for char in chars {
            self.costume = Character(char)
            usleep(100000)
            self.level?.repaint(lock: false)
        }
        if(level?.session?.lives == 0) {
            level?.session?.endSession()
        } else {
            level?.reset()
        }
    }
    
}
