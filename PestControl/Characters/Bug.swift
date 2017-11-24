//
//  Bug.swift
//  PestControl
//
//  Created by Grey Grissom on 11/23/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import SpriteKit

enum BugSettings {
  static let bugDistance: CGFloat = 16
  
}
class Bug: SKSpriteNode {

  var animations: [SKAction] = []
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
    physicsBody?.categoryBitMask = PhysicsCategory.Bug
    physicsBody?.restitution = 0.5
    physicsBody?.allowsRotation = false 
    
    createAnimations(character: "bug")
    
  }
  
  func move() {
    //1
    let randomX = CGFloat(Int.random(min: -1, max: 1))
    let randomY = CGFloat(Int.random(min: -1, max: 1))
    
    let vector = CGVector(dx: randomX * BugSettings.bugDistance, dy: randomY * BugSettings.bugDistance)
    
    //2
    let moveBy = SKAction.move(by: vector, duration: 1)
    let moveAgain = SKAction.run(move)
    
    
    let direction = animationDirection(for: vector)
    
    if direction == .left {
      xScale = abs(xScale)
    } else if direction == .right {
      xScale = -abs(xScale)
    }
    
    run(animations[direction.rawValue], withKey: "animation")
    run(SKAction.sequence([moveBy, moveAgain]))
  }
  
  func die() {
    removeAllActions()
    texture = SKTexture(imageNamed: "bug_lt1")
    yScale = -1
    
    physicsBody = nil
    run(SKAction.sequence([SKAction.fadeOut(withDuration: 3), SKAction.removeFromParent()]))
  }
  
  
}

extension Bug: Animatable {}

