//
//  GameScene.swift
//  ColorSwitch
//
//  Created by S T Ξ F A N on 18/03/2020.
//  Copyright © 2020 tlemau. All rights reserved.
//

import SpriteKit

enum PhysicsCategory: UInt32 {
    case None = 0
    case Ball = 1
    case SwitchCategory = 2
}

class GameScene: SKScene {
    var colorSwitch: SKSpriteNode!
    var ballColor = 0
    var switchColor = 0
    
    var scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    // Colors in the right order
    let colors = [
        UIColor(named: "Yellow"),
        UIColor(named: "Magenta"),
        UIColor(named: "Purple"),
        UIColor(named: "Cyan"),
    ]
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        // One third of screen size
        let colorSwitchSize = frame.size.width / 3
        
        // Initialize color switch node
        colorSwitch = SKSpriteNode(imageNamed: "ColorSwitch")
        colorSwitch.size = CGSize(width: colorSwitchSize, height: colorSwitchSize)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minX + colorSwitchSize)
        
        // Set gravity and collisions
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width / 2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategory.SwitchCategory.rawValue
        
        // Set static
        colorSwitch.physicsBody?.isDynamic = false
        
        // Add node on screen
        addChild(colorSwitch)
        
        // Initialize score label
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = frame.size.width / 6
        scoreLabel.fontColor = UIColor(named: "Brown")
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func spawnBall() {
        ballColor = Int.random(in: 0..<colors.count)
        
        // One third of color switch (one twelth of screen size)
        let ballSize = frame.size.width / 12
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "Ball"), color: colors[ballColor]!, size: CGSize(width: ballSize, height: ballSize))
        
        ball.name = "Ball"
        ball.colorBlendFactor = 1.0
        ball.position = CGPoint(x: frame.midX, y: frame.maxY - 5 * ball.size.height)
        
        // Set gravity and collisions
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball.rawValue
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.SwitchCategory.rawValue
        
        // Add ball on screen
        addChild(ball)
    }
    
    func turnWheel() {
        if (switchColor != colors.count - 1) {
            switchColor += 1
        } else {
            switchColor = 0
        }
        
        // Color switch turns clockwise
        colorSwitch.run(SKAction.rotate(byAngle: .pi / -2, duration: 0.25))
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if (contactMask == PhysicsCategory.Ball.rawValue | PhysicsCategory.SwitchCategory.rawValue) {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if (ballColor == switchColor) {
                    score += 1
                    updateScoreLabel()
                    print("OK")
                } else {
                    print("NOT OK")
                }
                
                ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                    ball.removeFromParent()
                    self.spawnBall()
                })
            }
        }
    }
}
