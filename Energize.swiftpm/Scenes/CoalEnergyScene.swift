//
//  File.swift
//  
//
//  Created by Gustavo Munhoz Correa on 08/04/23.
//

import SpriteKit
import AVFAudio

class CoalEnergyScene: SKScene {    
    let background = SKSpriteNode(imageNamed: "sceneCoal")
    let char = SKSpriteNode(imageNamed: "char-thumbsup")
    let truck1 = SKSpriteNode(imageNamed: "coal-truck")
    let truck2 = SKSpriteNode(imageNamed: "coal-truck")
    let truck3 = SKSpriteNode(imageNamed: "coal-truck")
    let truck4 = SKSpriteNode(imageNamed: "coal-truck")
    let smoke1 = SKSpriteNode(imageNamed: "smoke1")
    let smoke2 = SKSpriteNode(imageNamed: "smoke2")
    let smoke3 = SKSpriteNode(imageNamed: "smoke3")
    let smoke4 = SKSpriteNode(imageNamed: "smoke4")
    let storytext = SKSpriteNode(imageNamed: "coal-text-1")
    let progressBar1 = SKSpriteNode(imageNamed: "progressbar-lvl1")
    let progressBar2 = SKSpriteNode(imageNamed: "progressbar-lvl2")
    let progressBar3 = SKSpriteNode(imageNamed: "progressbar-lvl3")
    let progressBar4 = SKSpriteNode(imageNamed: "progressbar-lvl4")
    let progressBar5 = SKSpriteNode(imageNamed: "progressbar-lvl5")
    
    let industrySound = URL(fileURLWithPath: Bundle.main.path(forResource: "coal", ofType: ".wav")!)
    var audioPlayer: AVAudioPlayer?
    var volumeFadeInTimer : Timer?
    var volumeFadeOutTimer : Timer?
    
    weak var gameManager: GameManager?
    
    let imageNames = [
            "coal-text-2", "coal-text-3", "coal-text-4", "coal-text-5",
            "coal-text-6", "coal-text-7", "coal-text-8"
    ]
    let charPositions = [
        "char-book", "char-chemical", "char-idea", "char-magnify",
        "char-openarms", "char-pointer", "char-showing", "char-thumbsup"
    ]
    
    var currentIndex = 0
    var truckIndex = 0
    
    var completed = false
    
    override func didMove(to view: SKView) {
        audioPlayer = try! AVAudioPlayer(contentsOf: industrySound)
        audioPlayer?.prepareToPlay()
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0
        audioPlayer?.play()
        
        volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.audioPlayer?.volume ?? 0 < 0.4 {
                self.audioPlayer?.volume += 0.005
            } else {
                timer.invalidate()
            }
        }
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)
        
        smoke1.position = CGPoint(x: frame.width * 0.05, y: frame.height * 0.692)
        smoke1.size = CGSize(width: frame.width * 0.1, height: frame.height * 0.32)
        smoke1.alpha = 0
        addChild(smoke1)
        
        smoke2.position = CGPoint(x: frame.width * 0.125, y: frame.height * 0.69)
        smoke2.size = CGSize(width: frame.width * 0.1, height: frame.height * 0.32)
        smoke2.alpha = 0
        addChild(smoke2)
        
        smoke3.position = CGPoint(x: frame.width * 0.435, y: frame.height * 0.9065)
        smoke3.size = CGSize(width: frame.width * 0.16, height: frame.height * 0.62)
        smoke3.alpha = 0
        addChild(smoke3)
        
        smoke4.position = CGPoint(x: frame.midX, y: frame.midY)
        smoke4.size = CGSize(width: frame.width, height: frame.height)
        smoke4.alpha = 0
        addChild(smoke4)
        
        char.position = CGPoint(x: frame.width * 0.2, y: frame.height * 0.21)
        char.size = CGSize(width: frame.width * 0.21, height: frame.height * 0.3)
        char.xScale = -1
        addChild(char)
        
        truck4.position = CGPoint(x: frame.width * 0.8, y: frame.height * 0.26)
        truck4.size = CGSize(width: frame.width * 0.14, height: frame.height * 0.097)
        truck4.name = "truck4"
        addChild(truck4)
        
        truck3.position = CGPoint(x: frame.width * 0.75, y: frame.height * 0.25)
        truck3.size = CGSize(width: frame.width * 0.14, height: frame.height * 0.097)
        truck3.name = "truck3"
        addChild(truck3)
        
        truck2.position = CGPoint(x: frame.width * 0.7, y: frame.height * 0.24)
        truck2.size = CGSize(width: frame.width * 0.14, height: frame.height * 0.097)
        truck2.name = "truck2"
        addChild(truck2)
        
        truck1.position = CGPoint(x: frame.width * 0.65, y: frame.height * 0.23)
        truck1.size = CGSize(width: frame.width * 0.14, height: frame.height * 0.097)
        truck1.name = "truck1"
        addChild(truck1)
        
        storytext.position = CGPoint(x: frame.width * 0.43, y: frame.height * 0.15)
        storytext.size = CGSize(width: frame.width * 0.44, height: frame.height * 0.14)
        addChild(storytext)
        
        progressBar1.position = CGPoint(x: frame.width * 0.935, y: frame.height * 0.80)
        progressBar1.size = CGSize(width: frame.width * 0.03, height: frame.height * 0.27)
        progressBar1.isHidden = true
        addChild(progressBar1)
        
        progressBar2.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.748)
        progressBar2.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar2.isHidden = true
        addChild(progressBar2)
        
        progressBar3.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.80)
        progressBar3.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar3.isHidden = true
        addChild(progressBar3)
        
        progressBar4.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.852)
        progressBar4.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar4.isHidden = true
        addChild(progressBar4)
        
        progressBar5.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.902)
        progressBar5.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar5.isHidden = true
        addChild(progressBar5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentIndex < imageNames.count - 2 {
            changeCharPosition()
            switch currentIndex {
            case 2:
                storytext.size = CGSize(width: frame.width * 0.44, height: frame.height * 0.23)
            case 3:
                storytext.size = CGSize(width: frame.width * 0.44, height: frame.height * 0.23)
            default:
                storytext.size = CGSize(width: frame.width * 0.47, height: frame.height * 0.19)
            }
            
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            currentIndex += 1
        } else if currentIndex == imageNames.count - 2 {
            currentIndex += 1
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            progressBar1.isHidden = false
            
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
            moveToSolar()
            
        } else {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            for node in touchedNodes {
                if ["truck1", "truck2", "truck3", "truck4"].contains(node.name) {
                    handleTruckClick()
                    break
                }
            }
        }
    }
    
    func handleTruckClick() {
        switch truckIndex {
        case 0:
            smoke1.run(SKAction.fadeIn(withDuration: 0.3))
            truck1.isHidden = true
            progressBar2.isHidden = false
        case 1:
            smoke2.run(SKAction.fadeIn(withDuration: 0.3))
            truck2.isHidden = true
            progressBar3.isHidden = false
        case 2:
            smoke3.run(SKAction.fadeIn(withDuration: 0.3))
            truck3.isHidden = true
            progressBar4.isHidden = false
        default:
            smoke4.run(SKAction.fadeIn(withDuration: 0.5))
            self.run(SKAction.playSoundFileNamed("bell.wav", waitForCompletion: false))
            truck4.isHidden = true
            progressBar5.isHidden = false
            completed = true
            changeCharPosition()
            storytext.texture = SKTexture(imageNamed: "coal-text-9")
        }
        self.run(SKAction.group([
            SKAction.playSoundFileNamed("furnace.wav", waitForCompletion: false),
            SKAction.speed(by: 2, duration: 0)
        ]))
        
        truckIndex += 1
    }
    
    func changeCharPosition() {
        let newPosition = charPositions.randomElement()!
        char.texture = SKTexture(imageNamed: newPosition)
    }
    
    func moveScenes() {
        gameManager?.goToScene(.solar)
    }
    
    func moveToSolar() {
        gameManager?.goToScene(.solar)
    }
}
