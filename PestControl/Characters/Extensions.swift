//
//  Extensions.swift
//  PestControl
//
//  Created by Grey Grissom on 11/22/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import Foundation
import SpriteKit

extension SKTexture
{
  convenience init(pixelImageNamed: String) {
    // to remove fuzziness around pixelated artwork graphic
    self.init(imageNamed: pixelImageNamed)
    self.filteringMode = .nearest
    
  }
}
