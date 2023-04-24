//
//  GameManager.swift
//  Energize
//
//  Created by Gustavo Munhoz Correa on 18/04/23.
//
import SwiftUI
import SpriteKit

class GameManager: ObservableObject {
    @Published var selectedScene = Scenes.start
    @Published var opacity: Double = 1.0
    
    func goToScene(_ scene: Scenes){
        withAnimation(.easeInOut(duration: 0.5)) {
            self.opacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectedScene = scene
            
            withAnimation(.easeInOut(duration: 0.5)) {
                self.opacity = 1.0
            }
        }
    }
}
