//
//  Hangman.swift
//  Milestone Projects 7-9
//
//  Created by Dimas on 31/08/21.
//

import UIKit

class HangmanView: UIView {

	override func draw(_ rect: CGRect) {
		//        createHanger()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	
	private func setup() {
		backgroundColor = .clear
	}
	
	private func createLine(from: (x: CGFloat, y: CGFloat), to: (x: CGFloat, y: CGFloat), animate: Bool = true, for duration: Double = 0.2) {
		let path = UIBezierPath()
		path.move(to: .init(x: from.x, y: from.y))
		path.addLine(to: .init(x: to.x, y: to.y))
		
		let shapeLayer = CAShapeLayer() // a special layer where paths can be rendered inside
		layer.addSublayer(shapeLayer)
		shapeLayer.path = path.cgPath
		shapeLayer.lineWidth = 5
		shapeLayer.strokeColor = .init(red: 0.9137, green: 0.9098, blue: 0.9059, alpha: 1)
		
		if animate {
			let animation = CABasicAnimation(keyPath: "strokeEnd")
			animation.fromValue = 0.0
			animation.toValue = 1.0
			animation.duration = duration
			animation.beginTime = CACurrentMediaTime() + 0 // I don't know why if I don't use this, the animation will be broken

			shapeLayer.add(animation, forKey: "strokeEnd")
		}
		
		
	}
	
	private func createStroke(from path: UIBezierPath, animate: Bool = true, for duration: Double = 0.2) {
		
		let shapeLayer = CAShapeLayer() // a special layer where paths can be rendered inside
		layer.addSublayer(shapeLayer)
		shapeLayer.path = path.cgPath
		shapeLayer.lineWidth = 5
		shapeLayer.strokeColor = .init(red: 0.9137, green: 0.9098, blue: 0.9059, alpha: 1)
		
		if animate {
			let animation = CABasicAnimation(keyPath: "strokeEnd")
			animation.fromValue = 0.0
			animation.toValue = 1.0
			animation.duration = duration
			animation.beginTime = CACurrentMediaTime() + 0.4
			
			shapeLayer.add(animation, forKey: nil)
		}
		
	}
	
	func createHanger() {
		createLine(from: (x: bounds.width/2, y: bounds.height), to: (x: 0, y: bounds.height))
		createLine(from: (x: bounds.width/2, y: bounds.width), to: (x: bounds.width, y: bounds.height))
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
			self?.createLine(from: (x: 0, y: (self?.bounds.height)!), to: (x: 0, y: 0))
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
			self?.createLine(from: (x: 0, y: 0), to: (x: (self?.bounds.width)!, y: 0))
		}
		
		setNeedsDisplay()
	}
	
}
