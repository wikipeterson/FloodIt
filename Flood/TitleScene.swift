//
//  TitleScene.swift
//  Flood
//
//  Created by  on 5/16/19.
//  Copyright © 2019 WikipetersonApps. All rights reserved.
//

import UIKit
import SpriteKit

class TitleScene: SKScene
{
    let playButton = SKLabelNode(text: "Play")
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    let primaryArray : [UIColor] = [UIColor.blue, UIColor.red, UIColor.purple, UIColor.green, UIColor.yellow, UIColor.orange]
    var numNodes = 0
    var timer = Timer()
    
    override func didMove(to view: SKView)
    {
        
        screenWidth = frame.size.width
        screenHeight = frame.size.height
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom : self.frame)
        self.physicsBody!.friction = 0

        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(createNode), userInfo: nil, repeats: true)


        let label = SKLabelNode(text: "Bucket Fill!")
        label.fontName = "Arial"
        label.numberOfLines = 1
        label.fontSize = 70
        label.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        addChild(label)
        
        playButton.fontSize = 40
        playButton.fontName = "Arial"
        playButton.fontColor = UIColor.blue
        playButton.position = CGPoint(x: frame.width / 2, y: frame.height * 0.3)
        addChild(playButton)
    }
    
    
    @ objc func createNode()
    {
        var node = SKSpriteNode(color: primaryArray.randomElement()!, size: CGSize(width: screenWidth / 10, height: screenWidth / 10))
        node.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(screenWidth))) * 0.9 + CGFloat(arc4random_uniform(UInt32(screenWidth))) * 0.1, y: screenHeight * 0.4)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: screenWidth / 10, height: screenWidth / 10))
        node.physicsBody?.applyForce(CGVector(dx: 100, dy: 100))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.mass = 100
        
        self.addChild(node)
        
        numNodes += 1
        
        if numNodes > 29
        {
            timer.invalidate()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first?.location(in: self)
        
        if playButton.contains(touch!)
        {
            let scene = GameScene(size: view!.frame.size)
            let skView = view as! SKView
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            skView.presentScene(scene, transition: reveal)
        }
    }

}
