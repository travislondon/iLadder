//
//  Game.swift
//  iLadder
//
//  Created by Travis London on 1/23/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class Game : Equatable {
    var isRunning = false
    var name = ""
    var view : GameView?
    var rectToDraw : [CGRect]
    var livesLabel : UILabel?
    static var lastControl = 0
    
    public init(name : String) {
        isRunning = true
        self.name = name
        self.view = nil
        self.rectToDraw = [CGRect()]
    }
    
    public func draw(rect : CGRect) {
    }
    
    public func setLivesLabel(label : UILabel) {
        livesLabel = label
    }
    
    public static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.name == rhs.name
    }
    
    public func handleEvent(event: TouchEvent) {
    }
    
    public func gameOver() {
        // let subtypes override
    }
    
}
