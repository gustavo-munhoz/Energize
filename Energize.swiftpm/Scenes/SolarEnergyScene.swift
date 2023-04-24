//
//  SolarEnergyScene.swift
//  
//
//  Created by Gustavo Munhoz Correa on 10/04/23.
//

import SpriteKit
import CoreMotion
import AVFAudio

class SolarEnergyScene: SKScene {
    let motionManager = CMMotionManager()
    
    let background = SKSpriteNode(imageNamed: "sceneSolar")
    let solarPanels = SKSpriteNode(imageNamed: "solar-panel")
    let solarBody = SKSpriteNode(imageNamed: "solar-support")
    let char = SKSpriteNode(imageNamed: "char-showing")
    let storytext = SKSpriteNode(imageNamed: "solar-text-1")
    let illumination = SKSpriteNode(imageNamed: "illumination")
    let progressBar1 = SKSpriteNode(imageNamed: "progressbar-lvl1")
    let progressBar2 = SKSpriteNode(imageNamed: "progressbar-lvl2")
    let progressBar3 = SKSpriteNode(imageNamed: "progressbar-lvl3")
    let progressBar4 = SKSpriteNode(imageNamed: "progressbar-lvl4")
    let progressBar5 = SKSpriteNode(imageNamed: "progressbar-lvl5")
    let ipadIcon = SKSpriteNode(imageNamed: "ipad")
    
    let sunSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sun", ofType: ".wav")!)
    var audioPlayer: AVAudioPlayer?
    var volumeFadeInTimer : Timer?
    var volumeFadeOutTimer : Timer?
    weak var gameManager: GameManager?
    
    let imageNames = [
        "solar-text-2", "solar-text-3", "solar-text-4", "solar-text-5",
        "solar-text-6", "solar-text-7"
    ]
    
    let charPositions = [
        "char-book", "char-chemical", "char-idea", "char-magnify",
        "char-openarms", "char-pointer", "char-showing", "char-thumbsup"
    ]
    
    var currentIndex = 0
    var completed = false
    
    override func didMove(to view: SKView) {
        audioPlayer = try! AVAudioPlayer(contentsOf: sunSound)
        audioPlayer?.prepareToPlay()
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0
        audioPlayer?.play()
        
        volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.audioPlayer?.volume ?? 0 < 0.6 {
                self.audioPlayer?.volume += 0.005
            } else {
                timer.invalidate()
            }
        }
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        addChild(background)
        
        solarBody.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.34)
        solarBody.size = CGSize(width: frame.width * 0.055, height: frame.height * 0.225)
        addChild(solarBody)
        
        solarPanels.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.48)
        solarPanels.size = CGSize(width: frame.width * 0.55, height: frame.height * 0.15)
        solarPanels.zRotation = -0.42
        addChild(solarPanels)
        
        illumination.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.48)
        illumination.size = CGSize(width: frame.width * 0.55, height: frame.height * 0.165)
        illumination.zRotation = -0.42
        illumination.alpha = 0
        addChild(illumination)
        
        ipadIcon.position = CGPoint(x: frame.midX, y: frame.height * 0.8)
        ipadIcon.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
        ipadIcon.alpha = 0
        addChild(ipadIcon)
        
        char.position = CGPoint(x: frame.width * 0.2, y: frame.height * 0.21)
        char.size = CGSize(width: frame.width * 0.21, height: frame.height * 0.3)
        char.xScale = -1
        addChild(char)
        
        storytext.position = CGPoint(x: frame.width * 0.27, y: frame.height * 0.12)
        storytext.size = CGSize(width: frame.width * 0.38, height: frame.height * 0.16)
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
            if currentIndex == 2 {
                storytext.size = CGSize(width: frame.width * 0.35, height: frame.height * 0.165)
            } else {
                storytext.size = CGSize(width: frame.width * 0.38, height: frame.height * 0.16)
            }
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            currentIndex += 1
            
        } else if currentIndex == imageNames.count - 2 {
            changeCharPosition()
            currentIndex += 1
            storytext.size = CGSize(width: frame.width * 0.38, height: frame.height * 0.16)
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            progressBar1.isHidden = false
            startMonitoringGyroscope()
            
            let rotateToLeft = SKAction.rotate(toAngle: -CGFloat.pi / 6, duration: 0.7)
            let rotateToRight = SKAction.rotate(toAngle: CGFloat.pi / 6, duration: 0.7)

            let rotationSequence = SKAction.sequence([rotateToLeft, rotateToRight])

            let repeatRotation = SKAction.repeat(rotationSequence, count: 2)

            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let removeNode = SKAction.removeFromParent()
            let fadeOutAndRemove = SKAction.sequence([fadeOut, removeNode])

            let fullAnimation = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5) ,repeatRotation, fadeOutAndRemove])

            ipadIcon.run(fullAnimation)
            
        } else if completed {
            volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.audioPlayer?.volume ?? 0.6 > 0 {
                    self.audioPlayer?.volume -= 0.01
                } else {
                    audioPlayer?.stop()
                    timer.invalidate()
                }
            }
            moveToLab()
        }
    }
    
    func startMonitoringGyroscope() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 1.0 / 60.0
            motionManager.startGyroUpdates(to: .main) { [self] (data, error) in
                guard let gyroData = data else { return }
                
                let rotationRateX = gyroData.rotationRate.z
                let rotationAngle = CGFloat(rotationRateX) * CGFloat(self.motionManager.gyroUpdateInterval) * (0.85)
                let newZRotation = self.solarPanels.zRotation + rotationAngle
                
                let newAngleInDegrees = newZRotation * 180 / .pi

                if newAngleInDegrees >= -25 && newAngleInDegrees <= 25 {
                    self.solarPanels.zRotation = newZRotation
                    self.illumination.zRotation = newZRotation
                    switch newAngleInDegrees {
                    case -25...(-10):
                        progressBar2.isHidden = true
                        progressBar3.isHidden = true
                        progressBar4.isHidden = true
                        progressBar5.isHidden = true
                    case -10...0:
                        progressBar2.isHidden = false
                        progressBar3.isHidden = true
                        progressBar4.isHidden = true
                        progressBar5.isHidden = true
                    case 0...15:
                        progressBar2.isHidden = false
                        progressBar3.isHidden = false
                        progressBar4.isHidden = true
                        progressBar5.isHidden = true
                    case 15...24.9:
                        progressBar2.isHidden = false
                        progressBar3.isHidden = false
                        progressBar4.isHidden = false
                        progressBar5.isHidden = true
                    default:
                        progressBar2.isHidden = false
                        progressBar3.isHidden = false
                        progressBar4.isHidden = false
                    }
                }
                
                let rotationRateY = gyroData.rotationRate.y
                let scaleYChange = CGFloat(rotationRateY) * CGFloat(self.motionManager.gyroUpdateInterval) * 2
                
                solarPanels.yScale += scaleYChange
                solarPanels.yScale = max(min(self.solarPanels.yScale, 2), 0.5)
                illumination.yScale += scaleYChange
                illumination.yScale = max(min(self.solarPanels.yScale, 2), 0.5)
                
                let zRotationProgress = (newZRotation + 0.42) / 0.84
                let progress = zRotationProgress
                illumination.alpha = progress / 3
                
                if solarPanels.zRotation >= 0.42 && solarPanels.yScale <= 0.9 {
                    illumination.alpha = 0.4
                    progressBar5.isHidden = false
                    self.run(SKAction.playSoundFileNamed("bell.wav", waitForCompletion: false))
                    handleCompletion()
                }
            }
        }
    }
    
    func handleCompletion() {
        motionManager.stopGyroUpdates()
        storytext.texture = SKTexture(imageNamed: "solar-text-8")
        completed = true
    }
    
    func changeCharPosition() {
        let newPosition = charPositions.randomElement()!
        char.texture = SKTexture(imageNamed: newPosition)
    }
    
    func moveToLab() {
        gameManager?.goToScene(.lab)
    }
}
