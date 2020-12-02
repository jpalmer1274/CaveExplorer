//
//  GameScene.swift
//  CaveExplorer
//
//  Created by John Palmer on 11/30/20.
//  References: https://www.raywenderlich.com/71-spritekit-tutorial-for-beginners

import SpriteKit
import GameplayKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let monster   : UInt32 = 0b1       // 1
  static let projectile: UInt32 = 0b10      // 2
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var jumpButton: SKSpriteNode!
    var player1: SKSpriteNode!
    var moveDirection: String!
    var background = SKSpriteNode(imageNamed: "caveimage.jpg")
    
    override func didMove(to view: SKView) {
        // set up physics engine
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        

        guard let player1 = childNode(withName: "player") as? SKSpriteNode else {
            return
        }
        
        self.player1 = player1
        
        setUpControls()
        
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 5.0)
                ])
            ))
    }
    

    func setUpControls() {
        
        // Set the background
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        addChild(background)
        
        // Set controls
        leftButton = SKSpriteNode (imageNamed: "leftArrow")

        leftButton.position = CGPoint(x:-225, y:-102)

        leftButton.size = CGSize (width: 50, height: 50)
        
        leftButton.name = "Left"
        

        addChild(leftButton)


        rightButton = SKSpriteNode (imageNamed: "rightArrow")

        rightButton.position = CGPoint(x:-160, y:-103)

        rightButton.size = CGSize (width: 50, height: 50)
        
        rightButton.name = "Right"

        addChild(rightButton)
        
        jumpButton = SKSpriteNode (imageNamed: "upArrow")
        
        jumpButton.position = CGPoint(x:240, y:-103)

        jumpButton.size = CGSize (width: 55, height: 55)
        
        jumpButton.name = "Up"

        addChild(jumpButton)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }

    func addMonster() {
        
      
      // Create sprite
      let monster = SKSpriteNode(imageNamed: "batimage.png")
        monster.size = CGSize.init(width: 50, height: 40)
        
      monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
      monster.physicsBody?.isDynamic = true // 2
      monster.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
      monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
      monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5

      

      // Position the monster on the right edge,
      // and along a random position along the Y axis
      monster.position = CGPoint(x: size.width + monster.size.width/2, y: random(min: -100, max: 0))
      
      addChild(monster)
      
      // Determine speed of the monster
      let duration = random(min: CGFloat(5.0), max: CGFloat(8.0))
      
      // Create the actions
      let actionMove = SKAction.move(to: CGPoint(x: -200, y: random(min: -100, max: 0)),
                                     duration: TimeInterval(duration))
      let actionMoveDone = SKAction.removeFromParent()
      monster.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if (node.name == "Left") {
                // Implement your logic for left button touch here:
                self.moveDirection = "left"
                player1.position = CGPoint(x:player1.position.x-1, y:player1.position.y)
            } else if (node.name == "Right") {
                // Implement your logic for right button touch here:
                self.moveDirection = "right"
                player1.position = CGPoint(x:player1.position.x+1, y:player1.position.y)
            } else if (node.name == "Up") {
                self.moveDirection = "up"
            }
        }
        
    }
    
    func attackDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
      projectile.removeFromParent()
      monster.removeFromParent()
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.moveDirection = "none"
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
      
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "whip.png")
        projectile.size = CGSize.init(width: 100, height: 40)
        let whipXPosition = player1.position.x + 50
        let whipYPosition = player1.position.y + 5
        projectile.position = CGPoint(x:whipXPosition, y:whipYPosition)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

      
          // 3 - Determine offset of location to projectile
          let offset = touchLocation - projectile.position
          
          // 4 - Bail out if you are shooting down or backwards
            if offset.x < 0 {
                return
            }
          
          // 5 - OK to add now - you've double checked position
          addChild(projectile)
          
          // 6 - Get the direction of where to shoot
          let direction = offset.normalized()
          
          // 7 - Make it shoot far enough to be guaranteed off screen
          let shootAmount = direction
          
          // 8 - Add the shoot amount to the current position
          let realDest = shootAmount + projectile.position
          
          // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 0.25)
          let actionMoveDone = SKAction.removeFromParent()
          projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.moveDirection = "none"

    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (self.moveDirection == "left") {
            player1.position = CGPoint(x:player1.position.x-5, y:player1.position.y)
        } else if (self.moveDirection == "right") {
            player1.position = CGPoint(x:player1.position.x+5, y:player1.position.y)
        } else if (self.moveDirection == "up") {
            // move up 20
            let jumpUpAction = SKAction.moveBy(x: 0, y: 15, duration: 0.4)
            // move down 20
            let jumpDownAction = SKAction.moveBy(x: 0, y: -15, duration: 0.4)
            // sequence of move yup then down
            let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])

            // make player run sequence
            player1.run(jumpSequence)
        } else {
            
        }
    }

}

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
        if let monster = firstBody.node as? SKSpriteNode,
          let projectile = secondBody.node as? SKSpriteNode {
          attackDidCollideWithMonster(projectile: projectile, monster: monster)
        }
      }
    }

}
