//
//  Player.swift
//  PestControl
//
//  Created by Grey Grissom on 11/22/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerSettings
{
  static let playerSpeed: CGFloat = 280.0
}

class Player: SKSpriteNode {
  
  // because we create custom initializer
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
    
  }
  
  init()
  {
    let texture = SKTexture(imageNamed: "player_ft1")
    super.init(texture: texture, color: .white, size: texture.size())
    name = "Player"
    zPosition = 60
    
    // movement & physics
    physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
    physicsBody?.restitution = 10
    physicsBody?.linearDamping = 0.5
    physicsBody?.friction = 0.0
    physicsBody?.allowsRotation = false
  }
  
  
  // movement &  gestures
  
  /// makes player move toward `target`
  /// `newVelocity` describes the velocity of player
  ///
  /// - Parameter target: determines the direction
  func move(target: CGPoint)
  {
    guard let physicsBody = physicsBody else { return }
    
    let newVelocity = ( target - position).normalized() * PlayerSettings.playerSpeed
    physicsBody.velocity = CGVector(point: newVelocity)
  
  }
}
