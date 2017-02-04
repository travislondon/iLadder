//
//  TitleScreenController.swift
//  iLadder
//
//  Created by Travis London on 1/21/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class TitleScreenController : UIViewController {
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var exitButtonTv: UIButton!
    public static var levelSets = Array<iLevelSet>()

    @IBAction func handleNewGamePressed(_ sender: Any) {
        // perform transition to level set page, without
        // requiring individual level selection
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LevelSetViewController") as? LevelSetViewController
        controller?.transitionToLevelPage = false
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func handleExitButtonTVPressed(_ sender: Any) {
        close(0)
    }
    @IBAction func handleExitPressed(_ sender: Any) {
        close(0)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = TitleScene.newGameScene()
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // initialize level sets, only initialize once
        if(iLevelSet.levelSets.isEmpty) {
            initializeLevelSets()
        }
    }
    
    func initializeLevelSets() {
       TitleScreenController.levelSets = iLevelSet.getLevelSets()!
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

}
