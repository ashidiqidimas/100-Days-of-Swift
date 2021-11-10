//
//  GameScene.swift
//  Project11
//
//  Created by Dimas on 22/09/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	var scoreLabel: SKLabelNode!
	var boxLabel: SKLabelNode!
	var ballLabel: SKLabelNode!
	var resultLabel: SKLabelNode!
	
	let ballImages = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
	
	var scoreBefore = 0
	
	var score = 0 {
		
		willSet {
			scoreBefore = score
		}
		
		didSet {
			let color: UIColor
			if score > scoreBefore {
				color = .green
			} else {
				color = .red
			}
			
			scoreLabel.text = "Score: \(score)"
			scoreLabel.run(SKAction.scale(to: 1.25, duration: 0))
			scoreLabel.fontColor = color
			scoreLabel.run(SKAction.scale(to: 1, duration: 0.25)) { [weak self] in
				self?.scoreLabel.fontColor = .white
			}
		}
	}
	
	var boxLeft = 10 {
		didSet {
			boxLabel.text = "Box Left: \(boxLeft)"
			
			if boxLeft == 0 {
				resultLabel.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
			}
		}
	}
	
	var ballLeft = 3 {
		didSet {
			ballLabel.text = "Ball Left: \(ballLeft)"
		}
	}
	
	
    override func didMove(to view: SKView) {
		physicsWorld.contactDelegate = self
		
        let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: frame.width/2, y: frame.height/2)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.position = CGPoint(x: frame.width - 24, y: frame.height - (scoreLabel.frame.height + 24))
		addChild(scoreLabel)
		
		ballLabel = SKLabelNode(fontNamed: "Chalkduster")
		ballLabel.text = "Ball Left: \(ballLeft)"
		ballLabel.position = CGPoint(x: ballLabel.frame.width/2 + 24, y: scoreLabel.position.y)
		addChild(ballLabel)
		
		boxLabel = SKLabelNode(fontNamed: "Chalkduster")
		boxLabel.text = "Box Left: \(boxLeft)"
		boxLabel.position = CGPoint(x: frame.width/2, y: scoreLabel.position.y)
		addChild(boxLabel)
		
		resultLabel = SKLabelNode(fontNamed: "Chalkduster")
		resultLabel.text = "You Won!"
		resultLabel.fontSize = 80
		resultLabel.position = .init(x: frame.width/2, y: frame.height/2)
		resultLabel.run(SKAction.fadeAlpha(to: 0, duration: 0))
		addChild(resultLabel)
		
		let screenWidth = frame.width
		let screenHeight = frame.height
		
		for column in 0..<4 {
			if column % 2 == 0 {
				makeSlot(at: CGPoint(x: (Int(screenWidth/4) * column) + Int(screenWidth/8), y: 0), isGood: true)
			} else {
				makeSlot(at: CGPoint(x: (Int(screenWidth/4) * column) + Int(screenWidth/8), y: 0), isGood: false)
			}
		}
		
		for column in 0..<5 {
			makeBouncer(at: CGPoint(x: (Int(screenWidth/4) * column), y: 0))
		}
		
		for _ in 0..<boxLeft {
			makeBox(at: .init(x: CGFloat.random(in: 0...screenWidth), y: CGFloat.random(in: screenHeight/5...screenHeight-screenHeight/5)))
		}
		
		
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		let location = touch.location(in: self)
		
		makeBall(at: CGPoint(x: location.x, y: frame.height - 30))
	}
	
	func makeBox(at position: CGPoint) {
		let boxColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
		let boxSize = CGSize(width: CGFloat.random(in: 80...160), height: 16)
		let box = SKSpriteNode(color: boxColor, size: boxSize)
		box.physicsBody = .init(rectangleOf: boxSize)
		box.physicsBody?.isDynamic = false
		box.zRotation = CGFloat.random(in: 0...3)
		box.position = position
		box.name = "box"
		
		addChild(box)
	}
	
	func makeBall(at position: CGPoint) {
		let ball = SKSpriteNode(imageNamed: ballImages.randomElement()!)
		ball.name = "ball"
		ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width/2)
		ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
		ball.physicsBody?.restitution = 0.4
		ball.position = position
		
		addChild(ball)
	}
	
	func makeBouncer(at position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.frame.width/2)
		bouncer.physicsBody?.isDynamic = false

		addChild(bouncer)
	}
	
	func makeSlot(at position: CGPoint, isGood: Bool) {
		var slotBase: SKSpriteNode
		var slotGlow:SKSpriteNode
		
		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			slotBase.name = "good"
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			slotBase.name = "bad"
		}
		
		slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
		slotBase.physicsBody?.isDynamic = false

		slotBase.position = position
		slotGlow.position = position
		
		addChild(slotBase)
		addChild(slotGlow)
	}
	
}

extension GameScene: SKPhysicsContactDelegate {
	func destroy(_ object: SKNode) {
		if object.name == "box" {
			boxLeft -= 1
		} else {
			let fire = SKEmitterNode(fileNamed: "FireParticles")
			fire?.position = object.position
			addChild(fire!)
		}
		
		object.removeFromParent()
	}
	
	func collisionBetween(ball: SKNode, and object: SKNode) {
		if object.name == "good" {
			destroy(ball)
			score += 2
			ballLeft += 2
		} else if object.name == "bad" {
			destroy(ball)
			score -= 2
			ballLeft -= 1
		} else if object.name == "box" {
			destroy(object)
			score += 10
		}
		
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		
		if nodeA.name == "ball" {
			collisionBetween(ball: nodeA, and: nodeB)
		} else if nodeB.name == "ball" {
			collisionBetween(ball: nodeB, and: nodeA)
		}
	}
}
