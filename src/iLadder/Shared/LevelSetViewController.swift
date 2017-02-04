//
//  LevelCollectionView.swift
//  iLadder
//
//  Created by Travis London on 1/21/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class LevelSetViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var levelSetCollectionView: UICollectionView!

    public var transitionToLevelPage = true
    public var data = TitleScreenController.levelSets
    
    override public func viewDidLoad() {
        levelSetCollectionView.dataSource = self
        levelSetCollectionView.delegate = self
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelButton",
                                                      for: indexPath)
        let button =  (cell as? LevelCell)?.cellButton
        button?.setTitle(data[indexPath.item].name, for: UIControlState.normal)
        button?.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)

        // Configure the cell
        return cell
    }
    
    func buttonPressed(sender: UIButton) {
        let setName = sender.titleLabel?.text
        var set : iLevelSet? = nil
        for s in data {
            if(s.name == setName) {
                set = s
            }
        }
         if(transitionToLevelPage) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LevelViewController") as? LevelViewController
            controller?.levelSet = iLevelSet.getLevelSet(name: setName!)
            self.present(controller!, animated: true, completion: nil)
        } else {
            var game = GameManager.getManager().getGame(name: "")
            if(game == nil) {
                game = iLadderSession(name: (data[0].name), view: view)
                (game as! iLadderSession).levelSet = data[0]
                _ = (game as! iLadderSession).setLevel(newLevel: (set?.getLevel(index: 0))!)
                (game as! iLadderSession).startSession()
                GameManager.getManager().addGame(game: game!)
            } else {
                (game as! iLadderSession).startSession()
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
            controller?.setGame(game: game!)
            (game as! iLadderSession).controller = controller
            self.present(controller!, animated: true, completion: nil)
        }
    }
}
