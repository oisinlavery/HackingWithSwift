//
//  GameScene.swift
//  project11-oisin
//
//  Created by Oisín Lavery on 11/12/15.
//  Copyright (c) 2015 Oisín Lavery. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var scoreLabel: SKLabelNode!

    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var editLabel: SKLabelNode!

    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }

    override func didMoveToView(view: SKView) {

        physicsWorld.contactDelegate = self

        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)

        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)

        makeSlotAt(CGPoint(x: 128, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 384, y: 0), isGood: false)
        makeSlotAt(CGPoint(x: 640, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 896, y:0), isGood: false)

        makeBouncerAt(CGPoint(x: 0, y: 0))
        makeBouncerAt(CGPoint(x: 256, y: 0))
        makeBouncerAt(CGPoint(x: 512, y: 0))
        makeBouncerAt(CGPoint(x: 768, y: 0))
        makeBouncerAt(CGPoint(x: 1024, y: 0))

    }

    var ballColors = ["Blue", "Red", "Cyan", "Green", "Grey", "Purple", "Yellow"]
    var ballCount = 5
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)


            let objects = nodesAtPoint(location) as [SKNode]

            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else {

                if editingMode {

                    if (objects.contains(nodeAtPoint(location)) && nodeAtPoint(location).name == "box") {
                        nodeAtPoint(location).removeFromParent()
                    }
                    else{

                        let size = CGSize(width: GKRandomDistribution(lowestValue: 80, highestValue: 320).nextInt(), height: 16)
                        let box = SKSpriteNode(color: RandomColor(), size: size)
//                        box.zRotation = RandomCGFloat(min: 0, max: 3)
//                        box.runAction(SKAction.rotateByAngle(RandomCGFloat(min: 0, max: 3), duration: 0))

                        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 1)
                        let spinForever = SKAction.repeatActionForever(spin)
                        box.runAction(spinForever)

                        box.position = location
                        box.name = "box"
                        box.physicsBody = SKPhysicsBody(rectangleOfSize: box.size)
                        box.physicsBody!.dynamic = false

                        addChild(box)
                    }

                } else {

//                    if (location.y < 600) {
//                        return
//                    }

//                    if (ballCount > 0) {
//                        return
//                    }

                    let randomNumber = Int(GKRandomDistribution(lowestValue: 0, highestValue: ballColors.count - 1).nextInt())
                    let randomBallColor = ballColors[randomNumber]

                    let ball = SKSpriteNode(imageNamed: "ball\(randomBallColor)")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody!.restitution = 0.4
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                }

            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }

    func makeSlotAt(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position

        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 1)
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)

        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        slotBase.physicsBody!.dynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
    }

    func collisionBetweenBall(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            ++score
            --ballCount
            destroyBall(ball)
        } else if object.name == "bad" {
            --score
            ++ballCount
            destroyBall(ball)
        } else if object.name == "box" {
            object.removeFromParent()
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        if let bodyA = contact.bodyA.node {
            if let bodyB = contact.bodyB.node {
                if bodyA.name == "ball" {
                    collisionBetweenBall(bodyA, object: bodyB)
                } else if bodyB.name == "ball" {
                    collisionBetweenBall(bodyB, object: bodyA)
                }
            }
        }
    }

    func destroyBall(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
    }
}
