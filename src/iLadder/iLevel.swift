//
//  Level.swift
//  iLadder
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

extension CGPoint : Hashable {
    static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public var hashValue: Int {
        return Int(x) ^ Int(y)
    }
}

public class iLevel {
    var name = "?"
    var contents = ""
    var originalContents = ""
    var matrix : Array<Array<iLadderCharacter>>?
    var session : iLadderSession?
    var environment = Environment.init()
    var enemyBases = [iEnemyBase]()
    var fontAttributes : [String : UIFont]?
    var letterWidth = CGFloat(0)
    var letterHeight = CGFloat(0)
    var initialized = false
    var bounds = CGRect(x:0, y:0, width: 0, height:0)
    var floorLevels = Array<Int>()
    var fontSize = 12

    init(name : String, contents: String) {
        self.name = name
        self.contents = contents
        self.originalContents = contents
        environment.setLevel(level: self)
        setFont()
    }
    
    func setFont() {
        let font = UIFont.init(name:"Menlo", size:CGFloat(fontSize))!
        fontAttributes = [NSFontAttributeName: (font)]
        let myText = "H"
        let size = (myText as NSString).size(attributes: fontAttributes)
        letterWidth = size.width
        letterHeight = size.height
    }
    
    func startEnemyCreation() {
        // randomly choose a base to create an enemy from
        let random = Int(arc4random_uniform(UInt32(enemyBases.count)))
        if(enemyBases.count != 0) {
            enemyBases[random].randomlyCreateEnemy()
        }
    }
    
    func reset() {
        initialized = false
        self.unload()
        self.load()
    }
    
    func repaint(lock: Bool) {
        session?.repaint(useLock: lock)
    }
    
    func finished() {
        self.unload()
        var currentIndex = session?.levelSet?.indexOf(name: name)
        if(currentIndex! + 1 >= (session?.levelSet?.levelURLs.count)!) {
            // for now just restart
            currentIndex = -1
        }
        let nextLevelName = session?.levelSet?.getLevelNames()[currentIndex! + 1]
        let index = session?.levelSet?.indexOf(name: nextLevelName!)
        let nextLevel = session?.levelSet?.getLevel(index: index!)
        session?.setLevel(newLevel: nextLevel!)
    }
    
    func load() {
        let lines = contents.components(separatedBy: "\n")
        var y = 0
        var width = -1
        matrix = Array<Array<iLadderCharacter>>()
        for line in lines {
            var x = 0

            let characters = line.characters
            var xarray = Array<iLadderCharacter>()
            for char in characters {
                if(CGFloat(x) * letterWidth > CGFloat(width)) {
                    width = x
                }
                let character = iLadderCharacterFactory.createCharacter(character: char, level: self)
                character.setX(x: CGFloat(x))
                character.setY(y: CGFloat(y))
                if(character is iEnemyBase) {
                    enemyBases.append(character as! iEnemyBase)
                }
                if(character is iMovableCharacter) {
                    let blankChar = iLadderCharacterFactory.createCharacter(character: " ", level: self)
                    blankChar.setX(x: CGFloat(x))
                    blankChar.setY(y: CGFloat(y))
                    xarray.append(blankChar)
                } else {
                    // make note of floor level
                    if(character is iFloor) {
                        floorLevels.append(floorLevels.count + 1)   
                    }
                    // add to matrix
                    xarray.append(character)
                }
                x += 1
            }
            matrix?.append(xarray)
            y += 1
        }
        bounds.origin = CGPoint(x: 0, y: 0)
        bounds.size = CGSize(width: CGFloat(width), height: CGFloat(lines.count))
        // remove any movable characters from string
        for character in environment.characters {
            contents = contents.replacingOccurrences(of: String(character.costume), with: " ")
        }
    }
    
    func unload() {
        contents = originalContents
        matrix?.removeAll()
        enemyBases.removeAll()
        environment.characters.removeAll()
    }
    
    func draw(rect : CGRect) {
        for array in matrix! {
            for character in array {
                character.draw(rect: rect)
            }
        }
        for character in environment.characters {
            character.draw(rect: rect)
        }
    }
    
    public func update() {
        for character in environment.characters {
            character.update()
        }
        // ask the environment to readjust according
        // to nature's law
        environment.updateCharacters()
    }
    
    /*
        get the character at a given location
    */
    public func characterAt(x: CGFloat, y: CGFloat) -> iLadderCharacter? {
        let x = Int(floor(x))
        let y = Int(floor(y))
        if(y >= 0 && y < (matrix?.count)!) {
            if(x >= 0 && x < (matrix?[y].count)!) {
                return matrix?[y][x]
            }
        }
        return nil
    }
    
    /*
        Handle any touch events for all elements that
        support event handling
    */
    public func handleEvent(event : TouchEvent) {
        for character in environment.characters {
            character.handleEvent(event: event, sender: self)
        }
    }
}
