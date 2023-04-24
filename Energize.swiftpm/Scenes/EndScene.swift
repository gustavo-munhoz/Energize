//
//  EndScene.swift
//  
//
//  Created by Gustavo Munhoz Correa on 17/04/23.
//

import SpriteKit
import AVFAudio

class EndScene: SKScene {
    var endingType: EndingType
    weak var gameManager: GameManager?
    
    var goodPlayer: AVAudioPlayer?
    var volumeFadeInTimer : Timer?
    var volumeFadeOutTimer : Timer?
    let goodMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "good-end", ofType: ".aiff")!)
    var badPlayer: AVAudioPlayer?
    let badMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "bad-end", ofType: ".mp3")!)
    
    init(size: CGSize, endingType: EndingType) {
        goodPlayer = try! AVAudioPlayer(contentsOf: goodMusic)
        goodPlayer?.prepareToPlay()
        goodPlayer?.numberOfLoops = -1
        goodPlayer?.volume = 0
        badPlayer = try! AVAudioPlayer(contentsOf: badMusic)
        badPlayer?.prepareToPlay()
        badPlayer?.numberOfLoops = -1
        badPlayer?.volume = 0
        
        self.endingType = endingType
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let badBG = SKSpriteNode(imageNamed: "sceneBad1")

    let background = SKSpriteNode(imageNamed: "sceneGood1")
    let storytext = SKSpriteNode(imageNamed: "bad-text-1")
    var endingBackground: SKSpriteNode?
    var endingText: SKSpriteNode?
    
    let endTextBlack = SKSpriteNode(imageNamed: "the-end-black")
    let endTextWhite = SKSpriteNode(imageNamed: "the-end-white")
    
    var currentIndex = 0
    var playagain = false
    
    override func didMove(to view: SKView) {
        let CENTER = CGPoint(x: frame.midX, y: frame.midY)
    
        badBG.position = CENTER
        badBG.size = self.size
        
        if endingType == .COAL {
            goodPlayer?.play()
            volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.goodPlayer?.volume ?? 0 < 0.4 {
                    self.goodPlayer?.volume += 0.005
                } else {
                    timer.invalidate()
                }
            }
            
            let backgrounds = ["sceneGood1", "sceneGood2", "sceneGood3", "sceneBad1", "sceneBad2", "sceneBad3"]
            let texts = ["bad-text-1", "bad-text-2", "bad-text-3"]
            
            changeBackgroundAndText(index: 0, backgrounds: backgrounds, texts: texts, endingType: .COAL)
            
        } else {
            badPlayer?.play()
            volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.badPlayer?.volume ?? 0 < 0.4 {
                    self.badPlayer?.volume += 0.005
                } else {
                    timer.invalidate()
                }
            }
            
            let backgrounds = ["sceneBad1", "sceneBad2", "sceneBad3", "sceneGood1", "sceneGood2", "sceneGood3"]
            let texts = ["good-text-1", "good-text-2", "good-text-3"]
            
            changeBackgroundAndText(index: 0, backgrounds: backgrounds, texts: texts, endingType: .SOLAR)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if playagain {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            if touchedNodes.contains(endingText!) {
                volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    if self.badPlayer?.volume ?? 0.4 > 0 {
                        self.badPlayer?.volume -= 0.01
                    } else {
                        self.badPlayer?.stop()
                        timer.invalidate()
                        gameManager?.selectedScene = .wind
                    }
                }
                volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    if self.goodPlayer?.volume ?? 0.4 > 0 {
                        self.goodPlayer?.volume -= 0.01
                    } else {
                        self.goodPlayer?.stop()
                        timer.invalidate()
                        gameManager?.selectedScene = .wind
                    }
                }
            }
        }
    }
    
    func changeBackgroundAndText(index: Int, backgrounds: [String], texts: [String], endingType: EndingType) {
        let CENTER = CGPoint(x: frame.midX, y: frame.midY)
        if index < backgrounds.count {
            if index == 3 {
                if endingType == .COAL {
                    self.badPlayer?.play()
                    volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                        guard let self = self else { return }
                        if self.badPlayer?.volume ?? 0 < 0.4 {
                            self.badPlayer?.volume += 0.005
                        } else {
                            timer.invalidate()
                        }
                    }
                    volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                        guard let self = self else { return }
                        if self.goodPlayer?.volume ?? 0.4 > 0 {
                            self.goodPlayer?.volume -= 0.01
                        } else {
                            self.goodPlayer?.stop()
                            timer.invalidate()
                        }
                    }
                    
                } else {
                    self.goodPlayer?.play()
                    volumeFadeInTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                        guard let self = self else { return }
                        if self.goodPlayer?.volume ?? 0 < 0.4 {
                            self.goodPlayer?.volume += 0.005
                        } else {
                            timer.invalidate()
                        }
                    }
                    volumeFadeOutTimer = Timer.scheduledTimer(withTimeInterval: 2 / 100.0, repeats: true) { [weak self] timer in
                        guard let self = self else { return }
                        if self.badPlayer?.volume ?? 0.4 > 0 {
                            self.badPlayer?.volume -= 0.01
                        } else {
                            self.badPlayer?.stop()
                            timer.invalidate()
                        }
                    }
                }
            }
            
            let background = SKSpriteNode(imageNamed: backgrounds[index])
            background.position = CENTER
            background.size = self.size
            
            background.alpha = 0

            addChild(background)

            let fadeIn = SKAction.fadeIn(withDuration: 1.0)
            let instantFadeIn = SKAction.fadeIn(withDuration: 0)
            let wait = SKAction.wait(forDuration: 3.0)
            let fadeOut = SKAction.fadeOut(withDuration: 1.0)
            var sequence: SKAction
            
            if index == 5 {
                sequence = SKAction.sequence([fadeIn, wait])
            } else if index == 0 {
                sequence = SKAction.sequence([instantFadeIn, wait, fadeOut])
            } else {
                sequence = SKAction.sequence([fadeIn, wait, fadeOut])
            }

            if index == 1 || index == 3 || index == 5 {
                let storytext = SKSpriteNode(imageNamed: texts[index / 2])
                storytext.alpha = 0
                storytext.position = CGPoint(x: CENTER.x, y: frame.height * 0.8)
                storytext.size = CGSize(width: frame.width * 0.6, height: frame.height * 0.15)
                addChild(storytext)

                storytext.run(sequence)
            }

            background.run(sequence) {
                if index < 5 {
                    if index == 1 || index == 3 {
                        self.children.last?.removeFromParent()
                    }
                    background.removeFromParent()
                }
                self.changeBackgroundAndText(index: index + 1, backgrounds: backgrounds, texts: texts, endingType: endingType)
            }
        } else {
            if endingType == .COAL {
                endingBackground = SKSpriteNode(color: .black, size: self.size)
                endingBackground?.position = CENTER
                endingBackground?.alpha = 0
                addChild(endingBackground!)
        
                endingBackground?.run(SKAction.fadeIn(withDuration: 1.0))
                
                endingText = SKSpriteNode(imageNamed: "changeways")
                endingText?.position = CENTER
                endingText?.size = CGSize(width: frame.width * 0.55, height: frame.height * 0.15)
                addChild(endingText!)
                endingText?.run(SKAction.fadeIn(withDuration: 3))
                
                endTextWhite.position = CGPoint(x: CENTER.x, y: CENTER.y * 0.5)
                endTextWhite.size = CGSize(width: frame.width * 0.08, height: frame.height * 0.02)
                addChild(endTextWhite)
            } else {
                endingBackground = SKSpriteNode(color: .white, size: self.size)
                endingBackground?.position = CENTER
                endingBackground?.alpha = 0
                addChild(endingBackground!)
                
                endingBackground?.run(SKAction.fadeIn(withDuration: 1.0))
                
                endingText = SKSpriteNode(imageNamed: "thankyou")
                endingText?.position = CENTER
                endingText?.size = CGSize(width: frame.width * 0.35, height: frame.height * 0.12)
                addChild(endingText!)
                endingText?.run(SKAction.fadeIn(withDuration: 3))
                
                endTextBlack.position = CGPoint(x: CENTER.x, y: CENTER.y * 0.5)
                endTextBlack.size = CGSize(width: frame.width * 0.08, height: frame.height * 0.05)
                addChild(endTextWhite)
            }
            playagain = true
        }
    }

}
