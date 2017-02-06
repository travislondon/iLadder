//
//  GameView.swift
//  iLadder
//
//  Created by Travis London on 1/23/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class GameView : UIView {
    
    var game : Game!
    
    public func setGame(game: Game) {
        self.game = game
    }
    
    override public func draw(_ rect: CGRect) {
       game.draw(rect: rect)
    }
    
    override public var canBecomeFocused : Bool {
        return true
    }
    
}
