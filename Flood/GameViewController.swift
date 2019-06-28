//
//  GameViewController.swift
//  Flood
//
//  Created by  on 5/16/19.
//  Copyright © 2019 WikipetersonApps. All rights reserved.
//

import UIKit
import SpriteKit

let defaults = UserDefaults.standard

class GameViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let scene = TitleScene(size: view.frame.size)
        let skView = view as! SKView
        skView.presentScene(scene)
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
