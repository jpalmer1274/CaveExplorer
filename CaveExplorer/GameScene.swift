//
//  GameScene.swift
//  CaveExplorer
//
//  Created by John Palmer on 11/30/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var player: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var jumpButton: SKSpriteNode!
    var player1: SKSpriteNode!
    var moveDirection: String!
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // player = SKSpriteNode(imageNamed: "person")
        
       // player = GameScene.person
        
        guard let player1 = childNode(withName: "player") as? SKSpriteNode else {
            return
        }
        
        self.player1 = player1
        
        // addChild(self.player1)
        
//        player.position = CGPoint(x: 160,y: -50)
//
//        player.size = CGSize(width: 100, height: 100)
//
//        addChild(player)
        
        leftButton = SKSpriteNode (imageNamed: "leftArrow")

        leftButton.position = CGPoint(x:-225, y:-102)

        leftButton.size = CGSize (width: 55, height: 55)
        
        leftButton.name = "Left"
        

        addChild(leftButton)


        rightButton = SKSpriteNode (imageNamed: "rightArrow")

        rightButton.position = CGPoint(x:-160, y:-103)

        rightButton.size = CGSize (width: 55, height: 55)
        
        rightButton.name = "Right"

        addChild(rightButton)
        
        jumpButton = SKSpriteNode (imageNamed: "upArrow")
        
        jumpButton.position = CGPoint(x:240, y:-103)

        jumpButton.size = CGSize (width: 55, height: 55)
        
        jumpButton.name = "Up"

        addChild(jumpButton)
        
        // Create shape node to use during mouse interaction
        /*
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
 */
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }

        

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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.moveDirection = "none"
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
