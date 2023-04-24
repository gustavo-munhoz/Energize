//
//  _StartingScene.swift
//  
//
//  Created by Gustavo Munhoz Correa on 05/04/23.
//

import SpriteKit

class StartingScene: SKScene {
    weak var gameManager: GameManager?
    var finished = false
    let start = SKLabelNode(fontNamed: "Futura")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sceneWind1")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        addChild(background)
        
        let landscapeInstruction = SKSpriteNode(imageNamed: "landscapeInstruction")
        landscapeInstruction.position = CGPoint(x: frame.midX, y: frame.midY * 1.5)
        landscapeInstruction.size = CGSize(width: frame.width * 0.6, height: frame.height * 0.15)
        addChild(landscapeInstruction)
        
        let arrowInstruction = SKSpriteNode(imageNamed: "arrowInstruction")
        arrowInstruction.position = CGPoint(x: frame.midX, y: frame.midY)
        arrowInstruction.size = CGSize(width: frame.width * 0.5, height: frame.height * 0.15)
        addChild(arrowInstruction)

        let leftArrow = SKSpriteNode(imageNamed: "leftArrow")
        leftArrow.position = CGPoint(x: frame.minX + leftArrow.size.width / 2, y: frame.midY)
        leftArrow.size = CGSize(width: frame.width * 0.08, height: frame.height * 0.1)
        addChild(leftArrow)

        let rightArrow = SKSpriteNode(imageNamed: "rightArrow")
        rightArrow.position = CGPoint(x: frame.maxX - rightArrow.size.width / 2, y: frame.midY)
        rightArrow.size = CGSize(width: frame.width * 0.08, height: frame.height * 0.1)
        addChild(rightArrow)

        let volumeInstruction = SKSpriteNode(imageNamed: "volumeInstruction")
        volumeInstruction.position = CGPoint(x: frame.midX, y: frame.midY * 0.5)
        volumeInstruction.size = CGSize(width: frame.width * 0.35, height: frame.height * 0.06)
        addChild(volumeInstruction)
        
        

        landscapeInstruction.alpha = 0
        arrowInstruction.alpha = 0
        leftArrow.alpha = 0
        rightArrow.alpha = 0
        volumeInstruction.alpha = 0

        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let wait = SKAction.wait(forDuration: 1.0)

        let moveLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.5)
        let moveRight = SKAction.moveBy(x: 10, y: 0, duration: 0.5)
        let arrowSequenceLeft = SKAction.sequence([moveLeft, moveRight])
        let arrowSequenceRight = SKAction.sequence([moveRight, moveLeft])
        let arrowRepeatLeft = SKAction.repeatForever(arrowSequenceLeft)
        let arrowRepeatRight = SKAction.repeatForever(arrowSequenceRight)

        landscapeInstruction.run(SKAction.sequence([fadeIn, wait, fadeIn])) {
            arrowInstruction.run(SKAction.sequence([fadeIn, wait, fadeIn]))
            leftArrow.run(arrowRepeatLeft)
            rightArrow.run(arrowRepeatRight)
            leftArrow.run(SKAction.sequence([wait, fadeIn]))
            rightArrow.run(SKAction.sequence([wait, fadeIn])) {
                volumeInstruction.run(SKAction.sequence([wait, fadeIn])) {
                    self.run(SKAction.wait(forDuration: 4.0)) {
                        self.start.text = "touch to start"
                        self.start.fontColor = UIColor(hex: 0x315673)
                        self.start.fontSize = CGFloat(self.frame.width * self.frame.height) / 20000
                        self.start.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.05)
                        self.start.alpha = 0
                        self.addChild(self.start)
                        self.start.run(fadeIn)
                        self.finished = true
                    }
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if finished {self.gameManager?.goToScene(.wind)}
    }
}

