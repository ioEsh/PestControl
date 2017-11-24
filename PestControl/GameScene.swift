/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

class GameScene: SKScene {
  
  var player = Player()
//  var bug = Bug()
  var background: SKTileMapNode!
  var bugsNode = SKNode()
  var obstaclesTileMap: SKTileMapNode?
  var firebugCount: Int = 0
  var bugsprayTileMap: SKTileMapNode?
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    background = childNode(withName: "background") as! SKTileMapNode
    obstaclesTileMap = childNode(withName: "obstacles") as? SKTileMapNode
    
  }
  
  
  override func didMove(to view: SKView) {
    addChild(player)
//    addChild(bug)
//    bug.position = CGPoint(x: 60, y: 0 )
    setupCamera()
    setupWorldPhysics()
    createBugs()
    setupObstaclePhysics()
    
    if firebugCount > 0 {
      createBugspray(quantity: firebugCount + 10)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    
    player.move(target: touch.location(in: self))
  }

  override func update(_ currentTime: TimeInterval) {
    if !player.hasBugspray {
      updateBugspray()
    }
  }
}
// boundaries of game
extension GameScene
{
  func setupWorldPhysics()
  {
    background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
    background.physicsBody?.categoryBitMask = PhysicsCategory.Edge
    physicsWorld.contactDelegate = self
  }
}

// For camera settings
extension GameScene
{
  func setupCamera()
  {
    //1 -- check if camera is present
    guard let camera = camera, let view = view else { return }
    
    //2 -- create constraint keeping distance 0 from player
    let zeroDistance = SKRange(constantValue: 0)
    let playerConstraint = SKConstraint.distance(zeroDistance, to: player)
    
    //a -- determines the smallest distance from each edge that can be viewed without seeing gray out side boundaries , yet when the view is larger u ake the minimum and half the frame so to stay centeredd 
    let xInset = min(view.bounds.width/2 * camera.xScale, background.frame.width/2)
    let yInset = min(view.bounds.height/2 * camera.yScale, background.frame.height/2)
    
    //b
    let constraintRect = background.frame.insetBy(dx: xInset, dy: yInset)
    
    //c
    let xRange = SKRange(lowerLimit: constraintRect.minX, upperLimit: constraintRect.maxX)
    let yRange = SKRange(lowerLimit: constraintRect.minY, upperLimit: constraintRect.maxY)
    let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
    edgeConstraint.referenceNode = background
    
    
    //3 -- assignment of constraint to player
    camera.constraints = [playerConstraint, edgeConstraint]
    
  }
  
}

// for bug creation
extension GameScene {
  func tile(in tileMap: SKTileMapNode,
            at coordinates: TileCoordinates) -> SKTileDefinition? {
    return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
  }
  func createBugs() {
    guard let bugsMap = childNode(withName: "bugs") as? SKTileMapNode else { return }
    
    // cycle through the rows and columns of the tile map node
    for row in 0..<bugsMap.numberOfRows {
      for column in 0..<bugsMap.numberOfColumns {
        // get tile def at the row/column coordinate,
        // not nil means a bug is there
        guard let tile = tile(in: bugsMap,
                              at: (column, row)) else { continue }
        // bug sprite node ,
        let bug: Bug
        if tile.userData?.object(forKey: "firebug") != nil {
          bug = Firebug()
          firebugCount += 1
        } else {
          bug = Bug()
        }
        bug.position = bugsMap.centerOfTile(atColumn: column, row: row)
        bugsNode.addChild(bug)
        bug.move()
        
      }
    }
    // bugs NOde with child bugs to scene
    bugsNode.name = "bugs"
    addChild(bugsNode)
    //remove the tile map node
    bugsMap.removeFromParent()
  }

}

extension GameScene: SKPhysicsContactDelegate {
  
  func remove(bug: Bug) {
    bug.removeFromParent()
    background.addChild(bug)
    bug.die()
  }
  
  // Collisions
  func didBegin(_ contact: SKPhysicsContact) {
    let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
    
    switch other.categoryBitMask {
    case PhysicsCategory.Bug:
      if let bug = other.node as? Bug {
        remove(bug: bug)
      }
    case PhysicsCategory.Firebug:
      if player.hasBugspray {
        if let firebug = other.node as? Firebug {
          remove(bug: firebug)
          player.hasBugspray = false 
        }
      }
    default:
      break 
    }
    // when any contact notification occurs, check
    // the direction of player to orient Arnie in
    // correct direction  if hes not moving do nothing
    if let physicsBody = player.physicsBody {
      if physicsBody.velocity.length() > 0 {
        player.checkDirection()
      }
    }
  }
}
extension GameScene {
  
  
  func setupObstaclePhysics() {
    guard let obstaclesTileMap = obstaclesTileMap else { return }
    
    //1 create an array to hold all bodies of physics
//    var physicsBodies = [SKPhysicsBody]()
    
    //2 cycle through r/c in obstacles tmn
    for row in 0..<obstaclesTileMap.numberOfRows {
      for column in 0..<obstaclesTileMap.numberOfColumns {
        guard let tile = tile(in: obstaclesTileMap, at: (column, row)) else { continue }
        guard tile.userData?.object(forKey: "obstacle") != nil else { continue }
        let node = SKNode()
        node.physicsBody = SKPhysicsBody(rectangleOf: tile.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.friction = 0
        node.physicsBody?.categoryBitMask = PhysicsCategory.Breakable
        node.position = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
        obstaclesTileMap.addChild(node)
        //3 if tile def exists at specified r/c ,
        // create physics body of same size at the tile
//        let center = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
//        let body = SKPhysicsBody(rectangleOf: tile.size, center: center)
//        physicsBodies.append(body)
      }
    }
    
    //4
//    obstaclesTileMap.physicsBody = SKPhysicsBody(bodies: physicsBodies)
//    obstaclesTileMap.physicsBody?.isDynamic = false
//    obstaclesTileMap.physicsBody?.friction = 0
  }
}

extension GameScene {
  
  func tileCoordinates(in tileMap: SKTileMapNode, at position: CGPoint) -> TileCoordinates {
    let column = tileMap.tileColumnIndex(fromPosition: position)
    let row = tileMap.tileRowIndex(fromPosition: position)
    return (column, row)
  }
  func createBugspray(quantity: Int) {
    //1 create tile definition from bug pray image
    let tile = SKTileDefinition(texture: SKTexture(pixelImageNamed: "bugspray"))
    
    //2 create adjacency rule using said definition
    let tilerule = SKTileGroupRule(adjacency: SKTileAdjacencyMask.adjacencyAll, tileDefinitions: [tile])
    //3 create teh group from the adjacency rule
    let tilegroup = SKTileGroup(rules: [tilerule])
    //4 creating teh set from the group
    let tileSet = SKTileSet(tileGroups: [tilegroup])
   
    //5
    let columns = background.numberOfColumns
    let rows = background.numberOfRows
    bugsprayTileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tile.size)
    //6
    for _ in 1...quantity {
      let column = Int.random(min: 0, max: columns-1)
      let row = Int.random(min: 0, max: rows-1)
      bugsprayTileMap?.setTileGroup(tilegroup, forColumn: column, row: row)
    }
    
    //7
    bugsprayTileMap?.name = "Bugspray"
    addChild(bugsprayTileMap!)
  }
  
  func updateBugspray() {
    guard let bugsprayTileMap = bugsprayTileMap else { return }
    let (column, row) = tileCoordinates(in: bugsprayTileMap, at: player.position)
    if tile(in: bugsprayTileMap, at: (column, row)) != nil  {
      bugsprayTileMap.setTileGroup(nil, forColumn: column, row: row)
      player.hasBugspray = true
    }
  }
}
