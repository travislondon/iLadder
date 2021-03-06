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
    public var paused = true
    public var over = false
    public var controller : GameViewController?
    public var lock = UnfairLock.init()
    public var gameStarted = false
    var lastViewFrameSize = CGSize()
        
    override init(name : String) {
        super.init(name: name)
        self.sessionName = name + ":" + String(name.hash)
        self.initializeSession()
    }
    
    override public func startGame() {
        if(!gameStarted) {
            gameStarted = true
            startSession()
        }
    }
    
    func startSession() {
        paused = false
        over = false
        DispatchQueue.global(qos: .background).async {
            self.run()
        }
    }
    
    func run() {
        adjustScaling()
        currentLevel?.startEnemyCreation()
        currentLevel?.update()
    }
    
    func repaint(useLock: Bool) {
        self.updateLifeLabel()
        self.view?.setNeedsDisplay()
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
        unpause()
    }
    
    func adjustScaling() {
        let width = view?.frame.width
        let height = view?.frame.height
        let maxX = width! / (currentLevel?.bounds.width)!
        let maxY = height! / (currentLevel?.bounds.height)!
        // scale the font size to maximize screen real estate
        let font = getOptimalFont(maxX: maxX, maxY: maxY)
        currentLevel?.setFont(font: font)
    }
    
    func getOptimalFont(maxX: CGFloat, maxY:CGFloat) -> UIFont {
        var currentSize = CGFloat(60)
        var font = UIFont(name: "Menlo", size: currentSize)
        while(currentSize > 1) {
            font = UIFont(name: "Menlo", size: currentSize)
            let fontAttributes = [NSFontAttributeName: (font)]
            let myText = "H"
            let size = (myText as NSString).size(attributes: fontAttributes)
            if(maxX > size.width && maxY > size.height) {
                break
            }
            currentSize -= 0.5
        }
        return font!
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
