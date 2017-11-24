//
//  Types.swift
//  PestControl
//
//  Created by Grey Grissom on 11/22/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import SpriteKit

enum Direction: Int {
  case forward = 0, backward, left, right
  
}

typealias TileCoordinates = (column: Int, row: Int)

struct PhysicsCategory {
  static let None: UInt32 = 0
  static let All: UInt32 = 0xFFFFFFFF
  static let Edge: UInt32 = 0b1
  static let Player: UInt32 = 0b10
  static let Bug: UInt32 = 0b1 << 2
  static let Firebug: UInt32 = 0b1 << 3
  static let Breakable: UInt32 = 0b1 << 4
}

