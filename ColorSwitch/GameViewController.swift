//
//  GameViewController.swift
//  ColorSwitch
//
//  Created by S T Ξ F A N on 18/03/2020.
//  Copyright © 2020 tlemau. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            
            // Set scale mode to fit the window
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true // TODO ???
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
}
