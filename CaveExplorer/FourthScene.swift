//
//  FourthScene.swift
//  CaveExplorer
//
//  Created by Max Nelson on 12/13/20.
//

import SpriteKit
import GameplayKit


class FourthScene: SKScene, SKPhysicsContactDelegate {
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var jumpButton: SKSpriteNode!
    var player1: SKSpriteNode!
    var moveDirection: String!
    var background = SKSpriteNode(imageNamed: "caveimage")
    var leftWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var ceiling: SKSpriteNode!
    
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
        
        
        leftWall = childNode(withName: "leftWall") as? SKSpriteNode
        rightWall = childNode(withName: "rightWall") as? SKSpriteNode
        ceiling = childNode(withName: "ceiling") as? SKSpriteNode
    
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        ceiling.physicsBody?.categoryBitMask = PhysicsCategory.wall

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
    
    func displayLosingDialog() {
        let alert = UIAlertController(title: "You Lost!", message: "Try Again?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes!", style: .default, handler: { action in
                    let newScene = GameScene(fileNamed: "GameScene")
                    let animation = SKTransition.reveal(with: .left, duration: 1)
                    newScene?.scaleMode = .aspectFill
                    self.scene?.view?.presentScene(newScene!, transition: animation)
                         })
                    alert.addAction(ok)
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    
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
      let monster = SKSpriteNode(imageNamed: "batimage")
        monster.size = CGSize.init(width: 50, height: 40)
        
      monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
      monster.physicsBody?.isDynamic = true // 2
      monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
      monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
      monster.physicsBody?.collisionBitMask = PhysicsCategory.none

      

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
    
    func explorerDidColliedWithTrap(trap: SKSpriteNode, explorer: SKSpriteNode) {
            explorer.removeFromParent()
            displayLosingDialog()
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
        let whip = SKSpriteNode(imageNamed: "whip")
        whip.size = CGSize.init(width: 100, height: 40)
        let whipXPosition = player1.position.x + 50
        let whipYPosition = player1.position.y + 5
        whip.position = CGPoint(x:whipXPosition, y:whipYPosition)
        
        whip.physicsBody = SKPhysicsBody(circleOfRadius: whip.size.width/2)
        whip.physicsBody?.isDynamic = true
        whip.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        whip.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        whip.physicsBody?.collisionBitMask = PhysicsCategory.none
        whip.physicsBody?.usesPreciseCollisionDetection = true

          let offset = touchLocation - whip.position
            if offset.x < 0 {
                return
            }
          
          addChild(whip)

          let direction = offset.normalized()
          
          let amount = direction
          
          let realDest = amount + whip.position
          

        let actionMove = SKAction.move(to: realDest, duration: 0.25)
          let actionMoveDone = SKAction.removeFromParent()
            whip.run(SKAction.sequence([actionMove, actionMoveDone]))
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

extension FourthScene {
    func didBegin(_ contact: SKPhysicsContact) {
      
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
        if ((firstBody.node?.name == "") &&
                (secondBody.node?.name == "player")) {
        if let trap = firstBody.node as? SKSpriteNode,
           let explorer = secondBody.node as? SKSpriteNode {
            print("collided w spike trap")
            explorerDidColliedWithTrap(trap: trap, explorer: explorer)
        }
    }
        
        if (((firstBody.node?.name == "spider") || (firstBody.node?.name == "bat")) &&
                (secondBody.node?.name == "player")) {
            print("collided with monster")
            displayLosingDialog()
        }
      
      if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
        if let monster = firstBody.node as? SKSpriteNode,
          let projectile = secondBody.node as? SKSpriteNode {
          attackDidCollideWithMonster(projectile: projectile, monster: monster)
        }
      }
        
        if ((firstBody.node?.name == "rightWall") &&
                (secondBody.node?.name == "player")) {
            if let player = firstBody.node as? SKSpriteNode,
               let wall = secondBody.node as? SKSpriteNode {
                print("collided w wall")
                transferToNextScene()
            }
        }
    }

    func transferToNextScene() {
        let reveal = SKTransition.reveal(with: .down, duration: 1)
        let newScene = FifthScene(fileNamed: "FifthScene")
        newScene?.scaleMode = .aspectFill
        scene?.view?.presentScene(newScene!, transition: reveal)
    }

}

