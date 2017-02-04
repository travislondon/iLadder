//
//  iEnemyBase.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class iEnemyBase : iLadderCharacter {
    
    let maxEnemies = 18
    var createdEnemies = 0
    
    func randomlyCreateEnemy() {
        if(createdEnemies < maxEnemies) {
            let random = Int(arc4random_uniform(UInt32(200)))
            // create one if created enemies is < max and random number is
            // in the center
            if(random == 13 || random == 19) {
                var nextChar = level?.characterAt(x: location.x, y: location.y + 1)
                if(nextChar?.costume != " ") {
                    nextChar = level?.characterAt(x: location.x, y: location.y - 1)
                    if(nextChar?.costume != " ") {
                        nextChar = level?.characterAt(x: location.x + 1, y: location.y)
                        if(nextChar?.costume != " ") {
                            nextChar = level?.characterAt(x: location.x - 1, y: location.y)
                        }
                    }
                }
                let enemyLocation = CGPoint(x: (nextChar?.location.x)!, y: (nextChar?.location.y)!)
                let enemy = iLadderCharacterFactory.createCharacter(character: Character("!"), level: level!)
                enemy.setX(x: enemyLocation.x)
                enemy.setY(y: enemyLocation.y + 1)
                enemy.requiresPaint = true
                (enemy as! iMovableCharacter).direction = Direction.Down
                self.createdEnemies += 1
                (enemy as! iEnemy).base = self
            }
        }
    }
    
    public func enemyRemoved() {
        self.createdEnemies -= 1
    }
}
