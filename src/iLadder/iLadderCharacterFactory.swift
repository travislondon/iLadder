//
//  iLadderCharacterFactory.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

public class iLadderCharacterFactory {
    
    public static func createCharacter(character: Character, level: iLevel) -> iLadderCharacter {
        switch character {
        case "i":
            let agent = iAgent(costume: character, level: level)
            level.environment.characters.append(agent)
            return agent
        case "!":
            let enemy = iEnemy(costume: character, level: level)
            level.environment.characters.append(enemy)
            return enemy
        case "+":
            return iEnemyBase(costume: character, level: level)
        case "*":
            return iPOWCamp(costume: character, level: level)
        case "I":
            return iExtraLife(costume: character, level: level)
        case "%":
            return iScoreBoost(costume: character, level: level)
        case "D":
            return iDirector(costume: character, level: level)
        case "0":
            return iPortal(costume: character, level: level)
        case "=":
            return iFloor(costume: character, level: level)
        case "|":
            return iWall(costume: character, level: level)
        case "H":
            return iLadder(costume: character, level: level)
        case "·":
            return iDeflector(costume: character, level: level)
        case "@":
            return iPowerUp(costume: character, level: level)
        case "-":
            return iDisappearingFloor(costume: character, level: level)
        case "_":
            return iFalseFloor(costume: character, level: level)
        case "^":
            return iSpike(costume: character, level: level)
        default:
            return iLadderCharacter(costume: character, level: level)
        }
    }
    
}
