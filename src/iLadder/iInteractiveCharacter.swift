//
//  iInteractiveCharacter.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

public class iInteractiveCharacter : iLadderCharacter, iInstructable {
    
    public func canPassThrough(character: iLadderCharacter) -> Bool {
        return false
    }
    
    public func canConsume(character: iLadderCharacter) -> Bool {
        return false
    }
    
    public func moveTo(x: Int, y: Int, direction: Int) {
        
    }
    
    public func moveTo(character: iLadderCharacter) {
        
    }
    
    public func die() {
        
    }
    
    public func levelComplete() {
        
    }

}
