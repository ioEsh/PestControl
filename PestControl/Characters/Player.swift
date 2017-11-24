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
  
  
  var hasBugspray: Bool = false {
    didSet {
      blink(color: .green, on: hasBugspray)
    }
  }
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
    physicsBody?.categoryBitMask = PhysicsCategory.Player
    physicsBody?.contactTestBitMask = PhysicsCategory.All
    
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
extension Player {
  func blink(color: SKColor, on: Bool) {
    let blinkOff = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)
    if on {
      let blinkOn = SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.2)
      let blink = SKAction.repeatForever(SKAction.sequence([blinkOn, blinkOff]))
      xScale = xScale < 0 ? -1.5 : 1.5
      yScale = 1.5
      
      run(blink, withKey: "blinK")
    } else {
      xScale = xScale < 0 ? -1.0 : 1.0
      yScale = 1.0
      removeAction(forKey: "blink")
      run(blinkOff)
    }
  }
}
