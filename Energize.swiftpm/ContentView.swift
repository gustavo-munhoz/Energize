import SwiftUI
import SpriteKit

struct ContentView: View {    
    @StateObject var gameManager = GameManager()
       
    var body: some View {
        VStack {
            switch gameManager.selectedScene {
            case .start:
                SpriteView(scene: start())
            case .wind:
                SpriteView(scene: wind()).opacity(gameManager.opacity).background(.black)
            case .coal  :
                SpriteView(scene: coal()).opacity(gameManager.opacity).background(.black)
            case .solar:
                SpriteView(scene: solar()).opacity(gameManager.opacity).background(.black)
            case .lab:
                SpriteView(scene: lab()).opacity(gameManager.opacity).background(.black)
            case .goodEnd:
                SpriteView(scene: end(type: .SOLAR)).opacity(gameManager.opacity).background(.black)
            case .badEnd:
                SpriteView(scene: end(type: .COAL)).opacity(gameManager.opacity).background(.black)
            }
        }.ignoresSafeArea()
    }
    
    func start() -> SKScene {
        let screenSize = UIScreen.main.bounds.size
        let scene = StartingScene()
        scene.size = screenSize
        scene.scaleMode = .resizeFill
        scene.gameManager = gameManager
        return scene
    }
    
    func wind() -> SKScene {
        let screenSize = UIScreen.main.bounds.size
        let scene = WindEnergyScene()
        scene.size = screenSize
        scene.scaleMode = .resizeFill
        scene.gameManager = gameManager
        return scene
    }
    
    func coal() -> SKScene {
        let screenSize = UIScreen.main.bounds.size
        let scene = CoalEnergyScene()
        scene.size = screenSize
        scene.scaleMode = .resizeFill
        scene.gameManager = gameManager
        return scene
    }
    func solar() -> SKScene {
        let screenSize = UIScreen.main.bounds.size
        let scene = SolarEnergyScene()
        scene.size = screenSize
        scene.scaleMode = .resizeFill
        scene.gameManager = gameManager
        return scene
    }
    func lab() -> SKScene {
        let screenSize = UIScreen.main.bounds.size
        let scene = LabScene()
        scene.size = screenSize
        scene.scaleMode = .resizeFill
        scene.gameManager = gameManager
        return scene
    }
    func end(type: EndingType) -> SKScene {
        let screenSize = UIScreen.main.bounds.size
        let scene = EndScene(size: screenSize, endingType: type)
        scene.scaleMode = .resizeFill
        scene.gameManager = gameManager
        return scene
    }
    
}
