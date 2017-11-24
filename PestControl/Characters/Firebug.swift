//
//  Firebug.swift
//  PestControl
//
//  Created by Grey Grissom on 11/23/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//
import SpriteKit

import UIKit

class Firebug: Bug {

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  override init(){
      super.init()
    name = "Firebug"
    color = .red
    colorBlendFactor = 0.8
    physicsBody?.categoryBitMask = PhysicsCategory.Firebug
    }



}
