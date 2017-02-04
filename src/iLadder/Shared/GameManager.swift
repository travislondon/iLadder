//
//  GameManager.swift
//  iLadder
//
//  Created by Travis London on 1/23/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

public class GameManager {
    var games = Array<Game>()
    static var manager : GameManager?
    
    public static func getManager() -> GameManager {
        if(manager == nil) {
            manager = GameManager()
        }
        return manager!
    }
    
    public func addGame(game: Game) {
        games.append(game)
    }
    
    public func endGame(game: Game) {
        games.remove(at: games.index(of: game)!)
    }
    
    public func getGame(name: String) -> Game? {
        for game in games {
            if(game.name == name) {
                return game
            }
        }
        return nil
    }
}
