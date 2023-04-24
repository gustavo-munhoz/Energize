//
//  Scenes.swift
//  
//
//  Created by Gustavo Munhoz Correa on 18/04/23.
//

import SpriteKit

enum Scenes : String, Identifiable, CaseIterable {
    case start, wind, coal, solar, lab, goodEnd, badEnd
    
    var id: String {self.rawValue}
}
