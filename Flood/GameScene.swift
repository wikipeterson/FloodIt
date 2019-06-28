//
//  GameScene.swift
//  Flood
//
//  Created by  on 5/16/19.
//  Copyright © 2019 WikipetersonApps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    
    var gridSize = 5
    var squareSize: CGFloat = 0
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var nodeArray = [[SKSpriteNode]]()
    var colorArray: [UIColor] = []
    let primaryArray : [UIColor] = [UIColor.blue, UIColor.red, UIColor.purple, UIColor.green, UIColor.yellow, UIColor.orange]
    let melonArray : [UIColor] = [#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1), #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)]
    let deepArray : [UIColor] = [#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1), #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1), #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)]
    var colorSet = 0
    var buttonArray: [SKShapeNode] = []
    var scoreLabel = SKLabelNode(text: "")
    var settingsLabel = SKLabelNode(text: "Settings")
    var okayButton = SKLabelNode(text: "Continue?")
    
    var numberOfTurns = 0
    {
        didSet {
            scoreLabel.text = "Turns = \(numberOfTurns)"
        }
    }
    
    override func  didMove(to view: SKView)
    {
        colorSet = defaults.object(forKey:"Colors") as? Int ?? 0
        gridSize = defaults.object(forKey: "GameSize") as? Int ?? 15
        
        
        screenWidth = frame.size.width
        screenHeight = frame.size.height
        squareSize = screenWidth / CGFloat(gridSize)
        
        if colorSet == 0
        {
            colorArray = primaryArray
        }
        if colorSet == 1
        {
            colorArray = melonArray
        }
        if colorSet == 2
        {
            colorArray = deepArray
        }
        
        
        setUpLabels()
        setUpBoard()
        setUpButtons()
    }
    
    func setUpLabels()
    {
        settingsLabel = SKLabelNode(text: "Settings")
        scoreLabel = SKLabelNode(text: "")
        
        numberOfTurns = 0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.fontName = "Arial"
        scoreLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 3.5)
        addChild(scoreLabel)
        
        settingsLabel.fontColor = UIColor.blue
        settingsLabel.fontName = "Arial"
        settingsLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 4.2)
        addChild(settingsLabel)
    }
    
    func setUpBoard()
    {
        for j in 0..<gridSize
        {
            var row : [SKSpriteNode] = []
            for i in 0..<gridSize
            {
                let node = SKSpriteNode (color: colorArray.randomElement()!, size: CGSize(width: squareSize, height: squareSize))
                let xPos = squareSize / 2 + squareSize * CGFloat (i)
                let yPos = screenHeight * 0.9 - squareSize * CGFloat(j)
                let random = Int.random(in: 0...1)
                var destination = CGPoint(x: 0, y: 0)
                if random == 0
                {
                    node.position = CGPoint(x: 0, y: 0 )
                    //node.position = CGPoint(x: xPos, y: yPos )
                    destination = CGPoint(x: xPos, y: yPos )
                    
                }
                else
                {
                    node.position = CGPoint(x: screenWidth, y: 0)
                    destination = CGPoint(x: xPos - screenWidth, y: yPos )
                }
                addChild(node)
                //experimental bits
                //let destination = CGPoint(x: xPos, y: yPos )
                let path = CGMutablePath()
                path.move(to: node.position)
                path.addLine(to: destination)
                let moveAction = SKAction.follow(path, duration: 2)
                let rotateAction = SKAction.rotate(toAngle: 0, duration: 2)
                node.run(SKAction.group([moveAction, rotateAction]))
                
                row.append(node)
            }
            nodeArray.append(row)
        }
    }
    
    func setUpButtons()
    {
        let buttonWidth = screenWidth / 6
        
        for n in 0...5
        {
            let button = SKShapeNode (rect: CGRect(x: (buttonWidth * CGFloat (n)), y: CGFloat(-0.1 * screenHeight), width: buttonWidth, height: CGFloat(0.3 * screenHeight)), cornerRadius: buttonWidth / 2)
            button.fillColor = colorArray [n]
            button.strokeColor = colorArray[n]
            addChild(button)
            buttonArray.append(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first!.location(in: self)
        
        if settingsLabel.frame.contains(touch)
        {
            let scene = SettingsScene(size: view!.frame.size)
            let skView = view as! SKView
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            skView.presentScene(scene, transition: reveal)
        }
        
        for button in buttonArray
        {
            if button.frame.contains(touch)
            {
                if button.fillColor != nodeArray[0][0].color
                {
                    numberOfTurns += 1
                    fill(oldColor : nodeArray[0][0].color, newColor: button.fillColor, i: 0, j: 0)
                    checkForWin()
                }
            }
        }
        
        if okayButton.frame.contains(touch)
        {
            newGame()
        }

    }
    
    func checkForWin()
    {
        let color = nodeArray[0][0].color
        for i in 0..<gridSize
        {
            for j in 0..<gridSize
            {
                if nodeArray[i][j].color != color
                {
                    return
                }
            }
        }
        goToSettingsScene()
    }
    
    func goToSettingsScene()
    {
        print("winner")
        var turnsLabel = SKLabelNode(text: "You finished in \(numberOfTurns) turns.")
        turnsLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 1.3)
        turnsLabel.fontName = "Arial"
        addChild(turnsLabel)
        okayButton.position = CGPoint(x: screenWidth / 2, y: screenHeight / 1.5)
        okayButton.fontName = "Arial"
        addChild(okayButton)
    }
    
    func fill(oldColor : UIColor, newColor : UIColor, i : Int, j : Int)
    {
        if i >= 0 && i < gridSize && j >= 0 && j < gridSize
        {
            if nodeArray[i][j].color == oldColor
            {
                nodeArray[i][j].color = newColor
                fill(oldColor : oldColor, newColor: newColor, i: i-1, j: j)
                fill(oldColor : oldColor, newColor: newColor, i: i+1, j: j)
                fill(oldColor : oldColor, newColor: newColor, i: i, j: j-1)
                fill(oldColor : oldColor, newColor: newColor, i: i, j: j+1)
            }
        }

    }
    
    func newGame()
    {
        self.removeAllChildren()
        nodeArray = [[SKSpriteNode]]()
        buttonArray = []
        numberOfTurns = 0
        setUpBoard()
        setUpButtons()
        setUpLabels()
    }
}
