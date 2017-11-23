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
  
  var animations: [SKAction] = [] 
  // because we create custom initializer
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
    
  }
  
  init()
  {
    let texture = SKTexture(pixelImageNamed: "player_ft1")
    super.init(texture: texture, color: .white, size: texture.size())
    name = "Player"
    zPosition = 60
    
    // movement & physics
    physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
    physicsBody?.restitution = 10
    physicsBody?.linearDamping = 0.5
    physicsBody?.friction = 0.0
    physicsBody?.allowsRotation = false
    
    createAnimations(character: "player")
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
  
    print("* \(animationDirection(for: physicsBody.velocity))")
    
    checkDirection()
  }
  
  
  func checkDirection() {
    guard let physicsBody = physicsBody else { return }
    
    let direction = animationDirection(for: physicsBody.velocity)
    
    if direction == .left {
      xScale = abs(xScale)
    }
    
    if direction == .right {
      xScale = -abs(xScale)
    }
    
    run(animations[direction.rawValue], withKey: "animation")
  }
}


extension Player: Animatable { }
