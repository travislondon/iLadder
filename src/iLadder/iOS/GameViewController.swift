//
//  GameViewController.swift
//  iLadder
//
//  Created by Travis London on 1/21/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

public class GameViewController: UIViewController {
    
    var game : Game?
    
    @IBOutlet weak var livesLabel: UILabel!
    
    public func setGame(game: Game) {
        self.game = game
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        // configure the game view area
        let gameView = self.view.viewWithTag(3) as? GameView
        game!.view = gameView
        gameView?.setGame(game: game!)
    }
    
    #if os(iOS)
    override public var shouldAutorotate: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    #endif
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    #if os(iOS)
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    #endif
    
    override public func viewDidDisappear(_ animated: Bool) {
        game!.gameOver()
    }
    
    var touchStart = CGPoint(x:0, y:0)
    var touchDate : Date?
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchStart = (touches.first?.location(in: view))!
        touchDate = Date()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchEnd = touches.first?.location(in: view)
        let xDiff = touchStart.x - (touchEnd?.x)!
        let yDiff = touchStart.y - (touchEnd?.y)!
        if(abs(xDiff) < 5 && abs(yDiff) < 5) {
            // if the duration is longer than 1 second, generate
            // a stop
            let duration = NSDate().timeIntervalSince(touchDate! as Date)
            if(duration > 0.5) {
                let event = TouchEvent(type: TouchEvent.STOP)
                self.game?.handleEvent(event: event)
            } else {
                // generate a press, causing a jump
                let event = TouchEvent(type: TouchEvent.JUMP)
                self.game?.handleEvent(event: event)
            }
        } else {
            // determine move direction and generate appropriate
            // event
            let xChange = touchStart.x - (touchEnd?.x)!
            let yChange = touchStart.y - (touchEnd?.y)!
            if(abs(xChange) > abs(yChange)) {
                // we have a horizontal move
                // either left or right event
                if(xChange < 0) {
                    // moving right
                    let event = TouchEvent(type: TouchEvent.RIGHT)
                    self.game?.handleEvent(event: event)
                } else {
                    // moving left
                    let event = TouchEvent(type: TouchEvent.LEFT)
                    self.game?.handleEvent(event: event)
                }
            } else {
                // we have a vertical move
                // either up or down
                if(yChange < 0) {
                    // moving down
                    let event = TouchEvent(type: TouchEvent.DOWN)
                    self.game?.handleEvent(event: event)
                } else {
                    // moving up
                    let event = TouchEvent(type: TouchEvent.UP)
                    self.game?.handleEvent(event: event)
                }
            }
        }
    }
    
}
