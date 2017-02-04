//
//  Environment.swift
//  iLadder
//
//  Created by Travis London on 1/28/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class Environment {
    
    var characters = Array<iMovableCharacter>()
    var level : iLevel?
    
    func setLevel(level: iLevel) {
        self.level = level
    }
    
    func updateCharacters() {
        for character in characters {
            // assume the last location was 
            // checked, so skip if not moving
            if(character.moving) {
                if(character.location.x == round(character.location.x) || character.location.y == round(character.location.y)) {
                    handleNewLocation(character: character)
                }
            }
            applyGravity(character: character)
        }
    }
    
    func handleNewLocation(character : iMovableCharacter) {
        var nextCharacter = level?.characterAt(x: round(character.location.x), y: round(character.location.y))
        // if going up or left use floor
        if(character.direction == Direction.Up || character.direction == Direction.Left || character.jumping) {
            nextCharacter = level?.characterAt(x: floor(character.location.x), y: floor(character.location.y))
        }
        checkObstacles(character: character, nextCharacter: nextCharacter)
        // check next character again if above changed it
        nextCharacter = level?.characterAt(x: round(character.location.x), y: round(character.location.y))
        // if going up or left use floor
        if(character.direction == Direction.Up || character.direction == Direction.Left || character.jumping) {
            nextCharacter = level?.characterAt(x: floor(character.location.x), y: floor(character.location.y))
        }
        if(character.direction == Direction.Up || character.direction == Direction.Down) {
            // only allow if next character is iLadder
            if(!(nextCharacter is iLadder)) {
                // if not at a ladder, save this request
                // for next available ladder
                var prevCharacter = level?.characterAt(x: round(character.previousLocation.x), y: round(character.previousLocation.y))
                if(character.direction == Direction.Up) {
                    prevCharacter = level?.characterAt(x: floor(character.previousLocation.x), y: floor(character.previousLocation.y))
                }
                if(character.upOnNextChance == false && character.downOnNextChance == false && !(prevCharacter is iLadder)) {
                    if(character.direction == Direction.Up) {
                        character.upOnNextChance =  true
                    } else {
                        character.downOnNextChance = true
                    }
                    character.location = character.previousLocation
                    character.direction = character.previousDirection
                } else {
                    // normalize location
                    character.location.y = round(character.location.y)
                    if(character.direction == Direction.Up) {
                        character.location.y = floor(character.location.y)
                    }
                    character.upOnNextChance = false
                    character.downOnNextChance = false
                }
            }
        }
        if(character.direction == Direction.Right) {
            handleRightAttempt(character: character, nextCharacter: nextCharacter,  previousLocation: character.previousLocation)
        }
        if(character.direction == Direction.Left) {
            handleLeftAttempt(character: character, nextCharacter: nextCharacter,  previousLocation: character.previousLocation)
        }
    }
    
    func deflect(character: iMovableCharacter) {
        switch character.direction {
        case .Up:
            character.location.y += 5
            break
        case .Down:
            character.location.y -= 5
            break
        case .Left:
            character.location.x += 5
            break
        case .Right:
            character.location.x -= 5
        default:
            break
        }
    }
    
    func applyGravity(character: iMovableCharacter) {
        if(!character.jumping) {
            var nextCharacter = level?.characterAt(x: round(character.location.x), y: round(character.location.y + 1))
            if(character.direction == Direction.Up) {
                nextCharacter = level?.characterAt(x: floor(character.location.x), y: floor(character.location.y))
            }
            // do not apply gravity on ladders
            if(nextCharacter is iLadder) {
                return
            }
            if(nextCharacter == nil || nextCharacter?.costume == " ") {
                // if any floor is level with current location
                if(level?.floorLevels.contains(Int(character.location.y)))! {
                   //character.direction = Direction.Down
                }
                // update previousLocation
                character.previousLocation.y += 0.5
                character.location.y += 0.5
                // check obstacles, in the down direction if moving
                if(character.moving) {
                    checkObstacles(character: character, nextCharacter: nextCharacter)
                }
            }
            // normalize the final gravity led point
            character.location.y = round(character.location.y)
            // fell down a hole
            if(round(character.location.y) > CGFloat((level?.matrix?.count)!)) {
                character.die()
                return
            }
        }
    }
    
    func checkObstacles(character: iMovableCharacter, nextCharacter: iLadderCharacter?) {
        for movable in characters {
            if(movable is iAgent && character is iEnemy) {
                if(movable.location.x == character.location.x && movable.location.y == character.location.y) {
                    movable.die()
                    return
                }
            }
            if(movable is iEnemy && character is iAgent) {
                if(movable.location.x == character.location.x && movable.location.y == character.location.y) {
                    character.die()
                    return
                }
            }
        }
        if(character is iAgent && nextCharacter is iScoreBoost) {
            character.level?.session?.setScore(score: (character.level?.session?.score)! + 3000)
        }
        if(character is iAgent && nextCharacter is iDirector) {
            character.levelComplete()
            return
        }
        if(character is iEnemy && nextCharacter is iPOWCamp) {
            character.die()
            return
        }
        if(character is iEnemy && nextCharacter is iAgent) {
            (nextCharacter as! iAgent).die()
            return
        }
        if(character is iAgent && nextCharacter is iSpike) {
            character.die()
            return
        }
        if(nextCharacter is iDeflector) {
            deflect(character: character)
            return
        }
        if(nextCharacter is iLadder) {
            handleLadder(character: character, nextCharacter: nextCharacter, previousLocation: character.previousLocation)
            return
        }
        // check for ladder below or above
        let aboveChar = level?.characterAt(x: floor(character.location.x), y: floor(character.location.y - 1))
        let belowChar = level?.characterAt(x: round(character.location.x), y: round(character.location.y + 1))
        if(aboveChar is iLadder) {
            if(character.upOnNextChance) {
                character.location = (aboveChar?.location)!
                character.direction = Direction.Up
                character.upOnNextChance = false
                return
            }
        }
        if(belowChar is iLadder) {
            if(character.downOnNextChance) {
                character.location = (belowChar?.location)!
                character.direction = Direction.Down
                character.downOnNextChance = false
                return
            }
        }
        if(nextCharacter is iFloor) {
            character.location = character.previousLocation
            return
        }
        // stop at edges
        if(character.location.x < 0) {
            character.location = character.previousLocation
            return
        }
        if(character.location.x > (level?.bounds.maxX)!) {
            character.location = character.previousLocation
            return
        }
        if(character.location.y < (level?.bounds.minY)!) {
            character.location = character.previousLocation
            return
        }
        if(character.location.y > (level?.bounds.maxY)!) {
            character.location = character.previousLocation
            return
        }
        // consider adding this back once all interactive characters
        // are supported
//        if(nextCharacter != nil && nextCharacter?.costume != " ") {
//            character.location = character.previousLocation
//            return
//        }
        let characterBelow = level?.characterAt(x: round(character.location.x), y: round(character.location.y) + 1)
        if(characterBelow is iDisappearingFloor) {
            characterBelow?.costume = " "
        }
    }
    
    func handleRightAttempt(character: iMovableCharacter, nextCharacter: iLadderCharacter?, previousLocation: CGPoint) {
        if(nextCharacter is iWall) {
            character.location = previousLocation
            character.direction = Direction.None
            character.moving = false
        }
    }
    
    func handleLadder(character: iMovableCharacter, nextCharacter: iLadderCharacter?, previousLocation : CGPoint) {
        // adjust for correct ladder placement
        if(character.direction == Direction.Right) {
            character.location.x += 0.5
        }
        if(character.direction == Direction.Left) {
            character.location.x -= 0.5
        }
//        let previousCharacter = level?.characterAt(x: previousLocation.x, y: previousLocation.y)
//        let charBelow = level?.characterAt(x: round(character.location.x), y: round(character.location.y) + 1)
//        let charAbove = level?.characterAt(x: floor(character.location.x), y: floor(character.location.y) - 1)
//        if((charBelow is iLadder && previousCharacter?.costume == " ") && (charAbove is iLadder && previousCharacter?.costume == " ")) {
//            // pause on ladder
//            character.direction = Direction.None
//            character.moving = false
//        } else {
            if(character.upOnNextChance) {
                character.direction = Direction.Up
                character.upOnNextChance = false
            }
            if(character.downOnNextChance) {
                character.direction = Direction.Down
                character.downOnNextChance = false
            }
//        }
    }
    
    func handleLeftAttempt(character: iMovableCharacter, nextCharacter: iLadderCharacter?, previousLocation: CGPoint) {
        if(nextCharacter is iWall) {
            character.location = previousLocation
            character.direction = Direction.None
            character.moving = false
        }
    }
    
}
