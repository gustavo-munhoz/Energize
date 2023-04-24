//
//  WindEnergyScene.swift
//  Energize
//
//  Created by Gustavo Munhoz Correa on 04/04/23.
//

import SpriteKit
import AVFAudio

class WindEnergyScene: SKScene {
    weak var gameManager: GameManager?
    
    let skyNode = SKNode()
    let groundNode = SKNode()
    let cameraNode = SKCameraNode()
    
    let background1 = SKSpriteNode(imageNamed: "sceneWind1")
    let background2 = SKSpriteNode(imageNamed: "sceneWind2")
    
    let startScript = [
        "Energy is the driving force behind everything we do.",
        "From powering our homes to running our industries, " +
        "electrical energy plays a crucial role in our lives.",
        "But not all energy sources are created equal.",
        "Some can have a lasting impact on our environment.",
        "We need to make informed decisions about " +
        "which energy sources we choose to power our world.",
        "The future is in your hands."
    ]
    
    let appName = SKLabelNode(fontNamed: "Futura-Bold")
    let startText = SKLabelNode(fontNamed: "Futura")
    let instruction = SKLabelNode(fontNamed: "Futura")
    
    var hasStarted = false
    var shouldLower = false
    var startTextIndex = 0
    
    let char = SKSpriteNode(imageNamed: "char-showing")
    let windmillBody = SKSpriteNode(imageNamed: "windmill-body")
    let windmillBlades = SKSpriteNode(imageNamed: "windmill-blades")
    let windmillCenter = SKSpriteNode(imageNamed: "windmill-center")
    let progressBar1 = SKSpriteNode(imageNamed: "progressbar-lvl1")
    let progressBar2 = SKSpriteNode(imageNamed: "progressbar-lvl2")
    let progressBar3 = SKSpriteNode(imageNamed: "progressbar-lvl3")
    let progressBar4 = SKSpriteNode(imageNamed: "progressbar-lvl4")
    let progressBar5 = SKSpriteNode(imageNamed: "progressbar-lvl5")
    
    let storytext = SKSpriteNode(imageNamed: "wind-text-1")
    
    let audioManager = AudioManager()
    var volumeTimer: Timer?
    let eletricitySound = URL(fileURLWithPath: Bundle.main.path(forResource: "eletricity-flowing", ofType: ".mp3")!)
    let windSound = URL(fileURLWithPath: Bundle.main.path(forResource: "wind", ofType: ".wav")!)
    var audioPlayer: AVAudioPlayer?
    var volumeFadeInTimer : Timer?
    var volumeFadeOutTimer : Timer?
    
    let imageNames = [
            "wind-text-2", "wind-text-3", "wind-text-4", "wind-text-5",
            "wind-text-6", "wind-text-7"
        ]
    let charPositions = [
        "char-book", "char-chemical", "char-idea", "char-magnify",
        "char-openarms", "char-pointer", "char-showing", "char-thumbsup"
    ]
    
    var currentIndex = 0
    var completed = false
    
    override func didMove(to view: SKView) {
        audioPlayer = try! AVAudioPlayer(contentsOf: windSound)
        audioPlayer?.prepareToPlay()
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0
        audioPlayer?.play()
        
        volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.audioPlayer?.volume ?? 0 < 1 {
                self.audioPlayer?.volume += 0.005
            } else {
                timer.invalidate()
            }
        }
        
        skyNode.position = CGPoint(x: 0, y: size.height)
        groundNode.position = CGPoint(x: 0, y: 0)
        addChild(skyNode)
        addChild(groundNode)
    
        background1.position = CGPoint(x: frame.midX, y: size.height / 2)
        background1.size = CGSize(width: frame.width, height: frame.height)
        skyNode.addChild(background1)
        
        background2.position = CGPoint(x: frame.midX, y: size.height / 2)
        background2.size = CGSize(width: frame.width, height: frame.height)
        groundNode.addChild(background2)
        
        appName.text = "Energize"
        appName.fontColor = UIColor(hex: 0x315673)
        appName.fontSize = 120
        appName.position = CGPoint(x: frame.midX, y: frame.midY)
        
        instruction.text = "Touch anywhere to move forward"
        instruction.fontColor = UIColor(hex: 0x315673)
        instruction.alpha = 0.6
        instruction.fontSize = 54
        instruction.position = CGPoint(x: frame.midX, y: frame.midY * 0.5)
        let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.fadeIn(withDuration: 1)])
        instruction.run(SKAction.repeatForever(blink))
        
        startText.fontColor = UIColor(hex: 0x315673)
        startText.fontSize = frame.height * 0.05
        startText.position = CGPoint(x: frame.midX, y: frame.midY * 0.7)
        startText.preferredMaxLayoutWidth = frame.width * 0.9
        startText.lineBreakMode = .byWordWrapping
        startText.numberOfLines = 3
        
        
        skyNode.addChild(appName)
        skyNode.addChild(instruction)
        skyNode.addChild(startText)
        
        
        windmillBody.position = CGPoint(x: frame.width * 0.78, y: frame.height * 0.435)
        windmillBody.size = CGSize(width: frame.width * 0.2, height: frame.height * 0.57)
        groundNode.addChild(windmillBody)
        
        windmillBlades.position = CGPoint(x: frame.width * 0.692, y: frame.height * 0.67)
        windmillBlades.size = CGSize(width: frame.width * 0.37, height: frame.height * 0.5)
        let rotate = SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 1))
        windmillBlades.run(rotate)
        groundNode.addChild(windmillBlades)
        
        windmillCenter.position = CGPoint(x: frame.width * 0.69, y: frame.height * 0.672)
        windmillCenter.size = CGSize(width: frame.width * 0.02, height: frame.height * 0.03)
        groundNode.addChild(windmillCenter)
        
        char.position = CGPoint(x: frame.width * 0.3, y: frame.height * 0.19)
        char.size = CGSize(width: frame.width * 0.21, height: frame.height * 0.3)
        char.xScale = -1
        groundNode.addChild(char)
        
        progressBar1.position = CGPoint(x: frame.width * 0.935, y: frame.height * 0.80)
        progressBar1.size = CGSize(width: frame.width * 0.03, height: frame.height * 0.27)
        progressBar1.isHidden = true
        groundNode.addChild(progressBar1)
        
        progressBar2.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.748)
        progressBar2.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar2.isHidden = true
        groundNode.addChild(progressBar2)
        
        progressBar3.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.80)
        progressBar3.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar3.isHidden = true
        groundNode.addChild(progressBar3)
        
        progressBar4.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.852)
        progressBar4.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar4.isHidden = true
        groundNode.addChild(progressBar4)
        
        progressBar5.position = CGPoint(x: frame.width * 0.93505, y: frame.height * 0.902)
        progressBar5.size = CGSize(width: frame.width * 0.0241, height: frame.height * 0.055)
        progressBar5.isHidden = true
        groundNode.addChild(progressBar5)
        
        
        storytext.position = CGPoint(x: frame.width * 0.278, y: frame.height * 0.45)
        storytext.size = CGSize(width: frame.width * 0.481, height: frame.height * 0.195)
        groundNode.addChild(storytext)
        
        cameraNode.position = CGPoint(x: frame.midX, y: size.height * 1.5)
        camera = cameraNode
        addChild(cameraNode)
        
        audioManager.requestMicrophonePermission { granted in
            if granted {
                self.audioManager.setupAudioRecorder()
            } else {
                print("Microphone permission denied")
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasStarted {
            let hideStorytext = SKAction.fadeOut(withDuration: 0.5)
            let showStorytext = SKAction.fadeIn(withDuration: 0.25)
            
            if appName.position == CGPoint(x: frame.midX, y: frame.midY) {
                let moveappName = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY * 1.5), duration: 0.8)
                moveappName.timingMode = .easeInEaseOut
                appName.run(moveappName)
                instruction.removeAllActions()
                instruction.run(hideStorytext)
            }
            
            if startTextIndex < startScript.count - 1 {
                let changeStorytext = SKAction.run { [self] in
                    startText.text = startScript[startTextIndex]
                    startTextIndex += 1
                }
                startText.run(SKAction.sequence([hideStorytext, changeStorytext, showStorytext]))
                
            } else if startTextIndex == startScript.count - 1 {
                appName.run(SKAction.fadeOut(withDuration: 0.2))
                startText.run(SKAction.sequence([
                    hideStorytext,
                    SKAction.run { [self] in
                        startText.position = CGPoint(x: frame.midX, y: frame.midY)
                        startText.text = startScript[startTextIndex]
                        startTextIndex += 1
                    },
                    showStorytext
                ]))
                self.shouldLower = true
                self.hasStarted = true
            }
        } else if shouldLower {
            let lower = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 2)
            lower.timingMode = .easeInEaseOut
            cameraNode.run(lower)
            shouldLower = false
        }
        else if currentIndex < imageNames.count - 2 {
            changeCharPosition()
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            currentIndex += 1
        } else if currentIndex == imageNames.count - 2 {
            currentIndex += 1
            storytext.texture = SKTexture(imageNamed: imageNames[currentIndex])
            progressBar1.isHidden = false
            volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.audioPlayer?.volume ?? 1 > 0 {
                    self.audioPlayer?.volume -= 0.05
                } else {
                    audioPlayer?.stop()
                    timer.invalidate()
                }
            }
            self.startMonitoringVolume()
            
        } else if completed {
            volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.audioPlayer?.volume ?? 0.8 > 0 {
                    self.audioPlayer?.volume -= 0.05
                } else {
                    audioPlayer?.stop()
                    timer.invalidate()
                }
            }
            moveToCoal()
        }
    }
    
    func startMonitoringVolume() {
        volumeTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let degrees = self.audioManager.volumeToRotationDegree(volume: self.audioManager.getMicrophoneVolume())
            
            var rotate = SKAction.rotate(byAngle: degrees, duration: 1)
            rotate.timingMode = .easeInEaseOut
            self.windmillBlades.run(rotate)
            
            switch degrees {
            case 0.72..<1.44:
                progressBar2.isHidden = false
                progressBar3.isHidden = true
                progressBar4.isHidden = true
                progressBar5.isHidden = true
            case 1.44..<2.16:
                progressBar2.isHidden = false
                progressBar3.isHidden = false
                progressBar4.isHidden = true
                progressBar5.isHidden = true
            case 2.16..<2.88:
                progressBar2.isHidden = false
                progressBar3.isHidden = false
                progressBar4.isHidden = false
                progressBar5.isHidden = true
            case 2.88..<3.60:
                progressBar2.isHidden = false
                progressBar3.isHidden = false
                progressBar4.isHidden = false
                progressBar5.isHidden = false
                rotate = SKAction.repeatForever(SKAction.rotate(byAngle: -360, duration: 1))
                windmillBlades.run(rotate)
                handleCompletion()
                self.volumeTimer?.invalidate()
                self.run(SKAction.playSoundFileNamed("bell.wav", waitForCompletion: false))
            default:
                progressBar2.isHidden = true
                progressBar3.isHidden = true
                progressBar4.isHidden = true
                progressBar5.isHidden = true
            }
        }
    }
    
    func handleCompletion() {
        audioPlayer = try! AVAudioPlayer(contentsOf: eletricitySound)
        audioPlayer?.prepareToPlay()
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0
        audioPlayer?.play()
        volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.audioPlayer?.volume ?? 0 < 0.8 {
                self.audioPlayer?.volume += 0.005
            } else {
                timer.invalidate()
            }
        }
        storytext.texture = SKTexture(imageNamed: "wind-text-8")
        completed = true
    }
    
    func changeCharPosition() {
        let newPosition = charPositions.randomElement()!
        char.texture = SKTexture(imageNamed: newPosition)
    }
    
    func moveToCoal() {
        gameManager?.goToScene(.coal)
    }
}
