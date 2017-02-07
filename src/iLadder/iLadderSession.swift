//
//  iLadderSession.swift
//  iLadder
//
//  This is a session for the iLadder game.  It maintains
//  the level set that is being played.
//
//  Created by Travis London on 1/24/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SceneKit

public class iLadderSession : Game {
    private var sessionName : String?
    public var score = 0
    public var levelSet : iLevelSet?
    private var levelLabel : UILabel?
    private var currentLevel : iLevel?
    public var lives = 3
    private var paused = true
    public var over = false
    public var controller : GameViewController?
    public var lock = UnfairLock.init()
    var calculatedScale = false
    
    override init(name : String) {
        super.init(name: name)
        self.sessionName = name + ":" + String(name.hash)
        self.initializeSession()
    }
    
    func startSession() {
        paused = false
        over = false
        DispatchQueue.global(qos: .background).async {
            self.run()
        }
    }
    
    func run() {
        while(!self.over) {
            // skip unit view is loaded
            if(view == nil) {
                continue
            }
            if(!calculatedScale) {
                adjustScaling()
                calculatedScale = true
            }
            // we must lock updating
            // to prevent processing before
            // a last update was made
            lock.sync(execute: {
                currentLevel?.startEnemyCreation()
                currentLevel?.update()
            })
            repaint(useLock: true)
            Thread.sleep(forTimeInterval: 0.002)
        }
    }
    
    func repaint(useLock: Bool) {
        DispatchQueue.main.async {
            self.updateLifeLabel()
            self.view?.setNeedsDisplay()
        }
    }
    
    override public func gameOver() {
        self.endSession()
    }
    
    func pause() {
        paused = true
    }
    
    func unpause() {
        paused = false
    }
    
    func endSession() {
        over = true
        currentLevel?.reset()
    }
    
    func restartSession() {
        currentLevel?.reset()
    }
    
    /**
        Set some initialization data
     **/
    func initializeSession() {
        score = 0
        // initialize font and size dimensions
        
        setLevelSet()
    }
    
    func setScore(score: Int) {
        self.score = score
    }
    
    func setLevelSet() {
        if(self.levelSet != nil) {
            return;
        }
        for levelSet in TitleScreenController.levelSets {
            if(levelSet.name == name) {
                self.levelSet = levelSet
                break
            }
        }
    }
    
    func setLevel(newLevel : iLevel) {
        currentLevel = newLevel
        currentLevel?.session = self
        calculatedScale = false
    }
    
    func adjustScaling() {
        var ratio = (view?.frame.width)! / ((currentLevel?.bounds.width)! * (currentLevel?.letterWidth)!)
        let yRatio = (view?.frame.height)! / ((currentLevel?.bounds.height)! * (currentLevel?.letterHeight)!)
        if(ratio > yRatio) {
            ratio = yRatio
        }
        // scale the font size to maximize screen real estate
        currentLevel?.fontSize = Int(CGFloat((currentLevel?.fontSize)!) * ratio)
        currentLevel?.setFont()
    }
    
    func setLifeLabel(label : UILabel) {
        
    }
    
    func updateLifeLabel() {
        if(livesLabel == nil) {
            livesLabel = controller?.livesLabel
        }
        livesLabel?.text = "Lives: " + String(lives)
        livesLabel?.setNeedsDisplay()
    }
    
    func updateLevelLabel() {
        self.levelLabel?.text = self.currentLevel?.name
    }
    
    override public func draw(rect: CGRect) {
        currentLevel?.draw(rect: rect)
    }
    
    override public func handleEvent(event: TouchEvent) {
        lock.sync(execute: {currentLevel?.handleEvent(event: event)})
    }
    
}
