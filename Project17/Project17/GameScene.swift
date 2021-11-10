//
//  GameScene.swift
//  Project17
//
//  Created by Dimas on 10/11/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	let possibleEnemies = ["ball", "hammer", "tv"]
	var isGameOver = false
	var gameTimer: Timer?
	
	private var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	let starfield: SKEmitterNode = {
		let starfield = SKEmitterNode(fileNamed: "starfield")!
		starfield.position = .init(x: 1024, y: 384)
		starfield.zPosition = -1
		starfield.advanceSimulationTime(10)
		
		return starfield
	}()
	
	let player: SKSpriteNode = {
		let player = SKSpriteNode(imageNamed: "player")
		player.position = .init(x: 100, y: 384)
		player.physicsBody = .init(texture: player.texture!, size: player.size)
		player.physicsBody?.contactTestBitMask = 1
		
		return player
	}()
	
	let scoreLabel: SKLabelNode = {
		let scoreLabel = SKLabelNode(fontNamed: "chalkduster")
		scoreLabel.position = .init(x: 30, y: 80)
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.text = "Score: 0"
		
		return scoreLabel
	}()
    
    override func didMove(to view: SKView) {
		addChild(starfield)
        addChild(player)
		addChild(scoreLabel)
		
		physicsWorld.contactDelegate = self
		physicsWorld.gravity = .init(dx: 0, dy: 0)
		
		gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
		for node in children {
			if node.position.x < -300 {
				node.removeFromParent()
			}
		}
		
		if !isGameOver {
			score += 1
		}
    }
	
	@objc func createEnemy() {
		guard let enemy = possibleEnemies.randomElement() else { return }
		let sprite = SKSpriteNode(imageNamed: enemy)
		sprite.position = .init(x: 1200, y: Int.random(in: 50...736))
		
		sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
		sprite.physicsBody?.contactTestBitMask = 1
		sprite.physicsBody?.velocity = .init(dx: -500, dy: 0)
		sprite.physicsBody?.angularVelocity = 5
		sprite.physicsBody?.linearDamping = 0
		sprite.physicsBody?.angularDamping = 0
		
		addChild(sprite)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		var location = touch.location(in: self)
		
		if location.y < 100 {
			location.y = 100
		} else if location.y > 668 {
			location.y = 668
		}
		
		player.position = location
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		let explosion = SKEmitterNode(fileNamed: "explosion")!
		explosion.position = player.position
		addChild(explosion)
		
		player.removeFromParent()
		
		isGameOver = true
	}
}
