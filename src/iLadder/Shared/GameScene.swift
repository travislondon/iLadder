//
//  GameScene.swift
//  iLadder
//
//  Created by Travis London on 1/21/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit
#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

class GameScene: SKScene {
    
    var controller : GameViewController?
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }

        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif
    
    var lastDraw = 0.0
    override func update(_ currentTime: TimeInterval) {
        if(lastDraw == 0.0) {
            lastDraw = currentTime
        }
        if(currentTime - lastDraw > 0.07) {
            ((controller?.game) as! iLadderSession).run()
            controller?.game?.view?.setNeedsDisplay()
            lastDraw = currentTime
        }
    }
    
}
