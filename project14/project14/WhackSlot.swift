//
//  WhackSlot.swift
//  project14
//
//  Created by Dimas on 18/10/21.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
	
	var charNode: SKSpriteNode!
	
	var isVisible = false
	var isHit = false
	
	func configure(at position: CGPoint) {
		self.position = position
		let hole = SKSpriteNode(imageNamed: "whackHole")
		addChild(hole)

		let cropNode = SKCropNode()
		cropNode.position = CGPoint(x: 0, y: 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
		addChild(cropNode)

		charNode = SKSpriteNode(imageNamed: "penguinGood")
		charNode.position = CGPoint(x: 0, y: -90)
		charNode.name = "character"
		cropNode.addChild(charNode)
	}
	
	func show(hideTime: Double) {
		if isVisible { return }
		
		charNode.xScale = 1
		charNode.yScale = 1
	
		charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
		
		isVisible = true
		isHit = false
		
		if Int.random(in: 0...2) == 0 {
			charNode.texture = SKTexture(imageNamed: "penguinGood")
			charNode.name = "charFriend"
		} else {
			charNode.texture = SKTexture(imageNamed: "penguinEvil")
			charNode.name = "charEnemy"
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
			self?.hide()
		}
	}
	
	func hide() {
		if !isVisible { return }
		
		charNode.run(SKAction.moveTo(y: -90, duration: 0.05))
		isVisible = false
	}
	
	func hit() {
		if isHit { return }
		
		let smoke = SKEmitterNode(fileNamed: "Smoke")!
		smoke.position = self.charNode.position
		addChild(smoke)
		
		let delay = SKAction.wait(forDuration: 0.25)
		let hide = SKAction.moveTo(y: -90, duration: 0.5)
		let action = SKAction.run { [weak self] in self?.isVisible = false }
		let sequence = [delay, hide, action]
		charNode.run(SKAction.sequence(sequence))
	}
	
}
