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
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var livesLabel: UILabel!
    
    
    
    @IBAction func handleJumpPressed(_ sender: Any) {
        let event = TouchEvent(type: TouchEvent.JUMP)
        game?.handleEvent(event: event)
    }
    @IBAction func handleUpButtonPressed(_ sender: Any) {
        let event = TouchEvent(type: TouchEvent.UP)
        game?.handleEvent(event: event)
    }
    @IBAction func handleLeftButtonPressed(_ sender: Any) {
        let event = TouchEvent(type: TouchEvent.LEFT)
        game?.handleEvent(event: event)
    }
    @IBAction func handleRightButtonPressed(_ sender: Any) {
        let event = TouchEvent(type: TouchEvent.RIGHT)
        game?.handleEvent(event: event)
    }
    @IBAction func handleDownButtonPressed(_ sender: Any) {
        let event = TouchEvent(type: TouchEvent.DOWN)
        game?.handleEvent(event: event)
    }
    
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
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // configure the game view area
        let gameView = self.view.viewWithTag(3) as? GameView
        gameView?.setGame(game: game!)
        game!.view = gameView
    }

    override public var shouldAutorotate: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        game!.gameOver()
    }
    
}
