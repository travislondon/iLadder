//
//  TouchEvent.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

public class TouchEvent {
    static let LEFT = 0
    static let RIGHT = 1
    static let UP = 2
    static let DOWN = 3
    static let JUMP = 4
    
    init(type : Int) {
        self.type = type
    }
    
    public var type = -1
}
