//
//  LevelCollectionView.swift
//  iLadder
//
//  Created by Travis London on 1/21/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import SpriteKit

public class LevelViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var levelCollectionView: UICollectionView!
    var levelSet : iLevelSet?
    
    public var transitionToLevelPage = true
    public var data = Array<String>()
    
    override public func viewDidLoad() {
        levelCollectionView.dataSource = self
        levelCollectionView.delegate = self
        data = (levelSet?.getLevelNames())!
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell",
                                                      for: indexPath)
        let button =  (cell as? LevelCell)?.levelButton
        button?.setTitle(data[indexPath.item], for: UIControlState.normal)
        
        button?.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)

        // Configure the cell
        return cell
    }
    
    func buttonPressed(sender: UIButton) {
        let levelName = sender.titleLabel?.text
        var game = GameManager.getManager().getGame(name: levelName!)
        if(game == nil) {
            game = iLadderSession(name: levelName!)
            (game as! iLadderSession).levelSet = levelSet
            GameManager.getManager().addGame(game: game!)
        }
        _ = (game as! iLadderSession).setLevel(newLevel: (levelSet?.getLevel(index: (levelSet?.indexOf(name: levelName!))!))!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        controller?.setGame(game: game!)
        (game as! iLadderSession).controller = controller
        self.present(controller!, animated: true, completion: nil)
    }

}
