//
//  Bug.swift
//  PestControl
//
//  Created by Grey Grissom on 11/23/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import SpriteKit

class Bug: SKSpriteNode {

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  init()
  {
    let texture = SKTexture(imageNamed: "bug_ft1")
    super.init(texture: texture, color: .white, size: texture.size())
    name = "Bug"
    zPosition = 20
    
    physicsBody = SKPhysicsBody(circleOfRadius: size.width/2 )
    physicsBody?.restitution = 0.5
    physicsBody?.allowsRotation = false 
    
    
  }
  
  
}
