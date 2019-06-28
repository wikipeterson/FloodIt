//
//  SettingsScene.swift
//  Flood
//
//  Created by  on 5/24/19.
//  Copyright © 2019 WikipetersonApps. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsScene: SKScene
{
    var boardSize = 15
    
    let playButton = SKLabelNode(text: "Play")
    let colorSchemeLabel = SKLabelNode(text: "Color Scheme")
    let gridSizeLabel = SKLabelNode(text: "Grid Size")
    var colorButtonArray = [SKLabelNode]()
    var sizeButtonArray = [SKLabelNode]()
    var colorSet = 0
    
    override func didMove(to view: SKView)
    {

        colorSet = defaults.object(forKey:"Colors") as? Int ?? 0
        boardSize = defaults.object(forKey: "GameSize") as? Int ?? 15
        
        
            
        sizeButtonArray.append(SKLabelNode(text: "XS"))
        sizeButtonArray.append(SKLabelNode(text: "S"))
        sizeButtonArray.append(SKLabelNode(text: "M"))
        sizeButtonArray.append(SKLabelNode(text: "L"))
        sizeButtonArray.append(SKLabelNode(text: "XL"))
        
        
        colorButtonArray.append(SKLabelNode(text: "Basic"))
        colorButtonArray.append(SKLabelNode(text: "Melon"))
        colorButtonArray.append(SKLabelNode(text: "Deep"))
        
        
        for i in 0..<sizeButtonArray.count
        {
            sizeButtonArray[i].position = CGPoint(x: frame.width * CGFloat(i + 1) / CGFloat(sizeButtonArray.count + 1), y: frame.height * 0.7)
            sizeButtonArray[i].fontName = "Arial"
            if 5 + i * 5 == boardSize
            {
                sizeButtonArray[i].fontColor = UIColor.yellow
            }
            addChild(sizeButtonArray[i])
        }
        
        for i in 0..<colorButtonArray.count
        {
            colorButtonArray[i].position = CGPoint(x: frame.width * CGFloat(i + 1) / CGFloat(colorButtonArray.count + 1), y: frame.height * 0.5)
            colorButtonArray[i].fontName = "Arial"
            if colorSet == i
            {
                colorButtonArray[i].fontColor = UIColor.yellow
            }
    
            addChild(colorButtonArray[i])
        }
        
        
        gridSizeLabel.fontSize = 20
        gridSizeLabel.color = UIColor.lightGray
        gridSizeLabel.fontName = "Arial"
        gridSizeLabel.position = CGPoint(x: frame.width / 2, y: frame.height * 0.75)
        addChild(gridSizeLabel)
        
        
        colorSchemeLabel.fontSize = 20
        colorSchemeLabel.color = UIColor.lightGray
        colorSchemeLabel.fontName = "Arial"
        colorSchemeLabel.position = CGPoint(x: frame.width / 2, y: frame.height * 0.55)
        addChild(colorSchemeLabel)
        
        
        playButton.fontSize = 40
        playButton.fontName = "Arial"
        playButton.fontColor = UIColor.blue
        playButton.position = CGPoint(x: frame.width / 2, y: frame.height * 0.2)
        addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first?.location(in: self)
        
        if playButton.contains(touch!)
        {
            let scene = GameScene(size: view!.frame.size)
            scene.gridSize = boardSize
            scene.colorSet = colorSet
            
            defaults.set(boardSize, forKey: "GameSize")
            defaults.set(colorSet, forKey: "Colors")
            
            let skView = view as! SKView
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            skView.presentScene(scene, transition: reveal)
        }
        
        for i in 0..<sizeButtonArray.count
        {
            if sizeButtonArray[i].contains(touch!)
            {
                boardSize = 5 + i * 5
                
                for button in sizeButtonArray
                {
                    button.fontColor = UIColor.white
                }
                sizeButtonArray[i].fontColor = UIColor.yellow
            }
        }
        
        for i in 0..<colorButtonArray.count
        {
            if colorButtonArray[i].contains(touch!)
            {
                colorSet = i
                
                for button in colorButtonArray
                {
                    button.fontColor = UIColor.white
                }
                colorButtonArray[i].fontColor = UIColor.yellow
            }
        }
    }

    
    
}
