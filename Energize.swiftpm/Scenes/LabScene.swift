//
//  LabChoiceScene.swift
//  
//
//  Created by Gustavo Munhoz Correa on 13/04/23.
//

import SpriteKit
import AVFAudio

class LabScene: SKScene {
    weak var gameManager: GameManager?
    
    var audioPlayer: AVAudioPlayer?
    var chalkPlayer : AVAudioPlayer?
    var volumeFadeInTimer : Timer?
    var volumeFadeOutTimer : Timer?
    let labSound = URL(fileURLWithPath: Bundle.main.path(forResource: "lab", ofType: ".wav")!)
    let chalkSound = URL(fileURLWithPath: Bundle.main.path(forResource: "chalk", ofType: ".aiff")!)

    
    let background = SKSpriteNode(imageNamed: "sceneLab")
    let char = SKSpriteNode(imageNamed: "char-thumbsup")
    let storytext = SKSpriteNode(imageNamed: "lab-text-1")
    let blackboard = SKSpriteNode(imageNamed: "blackboard")
    
    let windButton = SKSpriteNode(imageNamed: "end-button-wind")
    let coalButton = SKSpriteNode(imageNamed: "end-button-coal")
    let solarButton = SKSpriteNode(imageNamed: "end-button-solar")
    let doneButton = SKSpriteNode(imageNamed: "done-button")
    let selected = SKSpriteNode(imageNamed: "selected")
    let redBorder = SKSpriteNode(imageNamed: "blackboard-border")
    let finalText = SKSpriteNode(imageNamed: "lab-text-end")
    
    let imageNames = [
        "lab-text-2", "lab-text-3", "lab-text-4", "lab-text-5",
        "lab-text-6"
    ]
    let choiceText = SKSpriteNode(imageNamed: "lab-text-7")
    
    let charPositions = [
        "char-book", "char-chemical", "char-idea", "char-magnify",
        "char-pointer", "char-showing", "char-thumbsup"
    ]
    
    var currentIndex = 0
    var finishedText = false
    var optionSelected = false
    var madeChoice = false
    var chosen: EndingType?
    var completed = false
    
    override func didMove(to view: SKView) {
        audioPlayer = try! AVAudioPlayer(contentsOf: labSound)
        audioPlayer?.prepareToPlay()
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0
        audioPlayer?.play()
        
        chalkPlayer = try! AVAudioPlayer(contentsOf: chalkSound)
        chalkPlayer?.prepareToPlay()
        
        volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.audioPlayer?.volume ?? 0 < 0.4 {
                self.audioPlayer?.volume += 0.005
            } else {
                timer.invalidate()
            }
        }
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        addChild(background)
        
        char.position = CGPoint(x: frame.width * 0.16, y: frame.height * 0.3)
        char.size = CGSize(width: frame.width * 0.32, height: frame.height * 0.48)
        char.xScale = -1
        addChild(char)
        
        blackboard.name = "blackboard"
        blackboard.position = CGPoint(x: frame.width * 0.415, y: frame.height * 0.61)
        blackboard.size = CGSize(width: frame.width * 0.33, height: frame.height * 0.223)
        blackboard.alpha = 0.01
        addChild(blackboard)
        
        redBorder.alpha = 0
        redBorder.position = CGPoint(x: frame.width * 0.42, y: frame.height * 0.61)
        redBorder.size = CGSize(width: blackboard.size.width * 0.97, height: blackboard.size.height * 1.05)
        addChild(redBorder)
        
        storytext.position = CGPoint(x: frame.width * 0.3, y: frame.height * 0.22)
        storytext.size = CGSize(width: frame.width * 0.4, height: frame.height * 0.15)
        addChild(storytext)
        
        finalText.position = storytext.position
        finalText.size = CGSize(width: frame.width * 0.4199, height: frame.height * 0.1983)
        finalText.isHidden = true
        
        windButton.isHidden = true
        coalButton.isHidden = true
        solarButton.isHidden = true
        choiceText.isHidden = true
        doneButton.isHidden = true
        selected.isHidden = true
        
        windButton.name = "end-button-wind"
        coalButton.name = "end-button-coal"
        solarButton.name = "end-button-solar"
        doneButton.name = "done-button"
        
        addChild(finalText)
        addChild(selected)
        addChild(doneButton)
        addChild(windButton)
        addChild(coalButton)
        addChild(solarButton)
        addChild(choiceText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentIndex < imageNames.count - 2 {
            changeCharPosition()
            if currentIndex == 0 {
                storytext.size = CGSize(width: frame.width * 0.39, height: frame.height * 0.19)
            } else {
                storytext.size = CGSize(width: frame.width * 0.37, height: frame.height * 0.13)
            }
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            currentIndex += 1
            
        } else if currentIndex == imageNames.count - 2 {
            char.texture = SKTexture(imageNamed: "char-pointer")
            currentIndex += 1
            
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            finishedText = true
            let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.fadeIn(withDuration: 0.5)])
            redBorder.run(SKAction.repeatForever(blink))
            
        } else if finishedText && !completed {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            for node in touchedNodes {
                if node.name == blackboard.name && !optionSelected {
                    redBorder.removeAllActions()
                    redBorder.alpha = 0
                    blackboard.isUserInteractionEnabled = false
                    background.texture = SKTexture(imageNamed: "sceneLab-blurred")
                    storytext.isHidden = true
                    char.isHidden = true
                    background.setScale(1.1)
                    
                    blackboard.position = CGPoint(x: frame.midX, y: frame.midY)
                    blackboard.alpha = 1
                    blackboard.setScale(2)
                    choiceText.position = CGPoint(x: frame.midX, y: blackboard.position.y * 1.65)
                    choiceText.size = CGSize(width: blackboard.size.width * 0.8, height: frame.height * 0.15)
                    
                    windButton.position = CGPoint(x: blackboard.position.x * 0.65, y: blackboard.position.y * 1.1)
                    coalButton.position = CGPoint(x: blackboard.position.x, y: blackboard.position.y * 0.78)
                    solarButton.position = CGPoint(x: blackboard.position.x * 1.35, y: blackboard.position.y * 1.1)
                    
                    windButton.size = CGSize(width: blackboard.size.width * 0.22, height: blackboard.size.height * 0.13)
                    coalButton.size = CGSize(width: blackboard.size.width * 0.22, height: blackboard.size.height * 0.13)
                    solarButton.size = CGSize(width: blackboard.size.width * 0.25, height: blackboard.size.height * 0.13)
                    
                    windButton.isHidden = false
                    coalButton.isHidden = false
                    solarButton.isHidden = false
                    choiceText.isHidden = false
                    
                } else if ["end-button-wind", "end-button-coal", "end-button-solar"].contains(node.name) {
                    optionSelected = true
                    chalkPlayer?.play()
                    switch node.name {
                    case "end-button-wind":
                        selected.position = CGPoint(x: windButton.position.x, y: windButton.position.y * 0.935)
                        selected.size = CGSize(width: windButton.size.width, height: windButton.size.height * 0.2)
                        chosen = .WIND
                    case "end-button-coal":
                        selected.position = CGPoint(x: coalButton.position.x, y: coalButton.position.y * 0.9)
                        selected.size = CGSize(width: coalButton.size.width, height: coalButton.size.height * 0.2)
                        chosen = .COAL
                    default:
                        selected.position = CGPoint(x: solarButton.position.x, y: solarButton.position.y * 0.935)
                        selected.size = CGSize(width: solarButton.size.width, height: solarButton.size.height * 0.2)
                        chosen = .SOLAR
                    }
                    selected.isHidden = false
                    
                    doneButton.position = CGPoint(x: blackboard.position.x * 1.55, y: blackboard.position.y * 0.64)
                    doneButton.size = CGSize(width: blackboard.size.width * 0.10, height: blackboard.size.height * 0.07)
                    doneButton.isHidden = false
                    
                } else if node.name == doneButton.name {
                    background.texture = SKTexture(imageNamed: "sceneLab-end")
                    background.setScale(1)
                    
                    switch chosen {
                    case .WIND:
                        selected.position = CGPoint(x: frame.width * 0.33, y: frame.height * 0.615)
                        selected.size = CGSize(width: frame.width * 0.072, height: frame.height * 0.005)
                    case .COAL:
                        selected.position = CGPoint(x: frame.width * 0.415, y: frame.height * 0.55)
                        selected.size = CGSize(width: frame.width * 0.071, height: frame.height * 0.005)
                    case .SOLAR:
                        selected.position = CGPoint(x: frame.width * 0.505, y: frame.height * 0.615)
                        selected.size = CGSize(width: frame.width * 0.077, height: frame.height * 0.005)
                    default: continue
                    }
                    
                    blackboard.isHidden = true
                    windButton.isHidden = true
                    coalButton.isHidden = true
                    solarButton.isHidden = true
                    choiceText.isHidden = true
                    doneButton.isHidden = true
                    storytext.isHidden = true
                    
                    char.texture = SKTexture(imageNamed: "char-book")
                    
                    finalText.isHidden = false
                    char.isHidden = false
                    completed = true
                }
            }
        } else if completed {
            volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.audioPlayer?.volume ?? 0.4 > 0 {
                    self.audioPlayer?.volume -= 0.05
                } else {
                    audioPlayer?.stop()
                    timer.invalidate()
                }
            }
            chosen == .COAL ? gameManager?.goToScene(.badEnd) : gameManager?.goToScene(.goodEnd)
        }
    }
    
    func changeCharPosition() {
        let newPosition = charPositions.randomElement()!
        char.texture = SKTexture(imageNamed: newPosition)
    }
}
