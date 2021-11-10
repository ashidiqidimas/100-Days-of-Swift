//
//  ViewController.swift
//  Project8
//
//  Created by Dimas on 25/08/21.
//

import UIKit

class ViewController: UIViewController {
	 
	// MARK: - Properties
	
	var cluesLabel: UILabel!
	var answersLabel: UILabel!
	var currentAnswer: UITextField!
	var scoreLabel: UILabel!
	var letterButtons = [UIButton]()
	var submitButton: UIButton!
	
	var activatedButtons = [UIButton]()
	var solutions = [String]()
	
	var level = 1
	var scoreBefore = 0
	var score = 0 {
		willSet {
			scoreBefore = score
		}
		
		didSet {
			updateScoreLabel()
		}
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		scoreLabel = UILabel()
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.textAlignment = .right
		scoreLabel.text = "Score: 0"
		view.addSubview(scoreLabel)
		
		cluesLabel = UILabel()
		cluesLabel.translatesAutoresizingMaskIntoConstraints = false
		cluesLabel.numberOfLines = 0
		cluesLabel.font = UIFont.systemFont(ofSize: 24)
		cluesLabel.text = "CLUES"
		cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		view.addSubview(cluesLabel)
		
		answersLabel = UILabel()
		answersLabel.translatesAutoresizingMaskIntoConstraints = false
		answersLabel.font = UIFont.systemFont(ofSize: 24)
		answersLabel.text = "ANSWERS"
		answersLabel.numberOfLines = 0
		answersLabel.textAlignment = .right
		answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		view.addSubview(answersLabel)
		
		currentAnswer =  UITextField()
		currentAnswer.translatesAutoresizingMaskIntoConstraints = false
		currentAnswer.isUserInteractionEnabled = false
		currentAnswer.placeholder = "Tap letter to guess"
		currentAnswer.textAlignment = .center
		currentAnswer.font = UIFont.systemFont(ofSize: 44)
		view.addSubview(currentAnswer)
		
		submitButton = UIButton(type: .system)
		submitButton.translatesAutoresizingMaskIntoConstraints = false
		submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
		submitButton.setTitle("SUBMIT", for: .normal)
		view.addSubview(submitButton)
		
		let clear  = UIButton(type: .system)
		clear.translatesAutoresizingMaskIntoConstraints = false
		clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
		clear.setTitle("CLEAR", for: .normal)
		view.addSubview(clear)
		
		let buttonsView = UIView()
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		buttonsView.layer.borderWidth = 1
		buttonsView.layer.borderColor = UIColor.lightGray.cgColor
		view.addSubview(buttonsView)
		
		NSLayoutConstraint.activate([
			scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			
			cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
			cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),
			
			answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
			answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100),
			
			answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
			
			currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
			currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
			
			submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
			submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
			submitButton.heightAnchor.constraint(equalToConstant: 44),
			
			clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
			clear.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
			clear.heightAnchor.constraint(equalToConstant: 44),
			
			buttonsView.widthAnchor.constraint(equalToConstant: 750),
			buttonsView.heightAnchor.constraint(equalToConstant: 320),
			buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
			buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
		])
		
		let buttonHeight = 80
		let buttonWidth = 150
		
		for row in 0 ..< 4 {
			for column in 0 ..< 5 {
				let letterButton = UIButton(type: .system)
				letterButton.setTitle("WWW", for: .normal)
				letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
				letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
				
				letterButton.frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
				
				letterButtons.append(letterButton)
				buttonsView.addSubview(letterButton)
			}
		}

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadLevel()
		
	}
	
	// MARK: - Button Methods
	
	@objc func letterTapped(_ sender: UIButton) {
		guard let buttonTitle = sender.titleLabel?.text else { return }
		
		currentAnswer.text?.append(buttonTitle)
		
		activatedButtons.append(sender)
		sender.isHidden = true
		
		if currentAnswer.layer.borderColor == UIColor.red.cgColor {
			submitButton.isEnabled = true
			currentAnswer.layer.borderWidth = 0
		}
	}
	
	@objc func submitTapped(_ sender: UIButton) {
		guard let answerText = currentAnswer.text else { return }
		
		if let solutionPosition = solutions.firstIndex(of: answerText) {
			var splitAnswer = answersLabel.text?.components(separatedBy: "\n")
			splitAnswer?[solutionPosition] = solutions[solutionPosition]
			answersLabel.text = splitAnswer?.joined(separator: "\n")
			
			currentAnswer.text = ""
			activatedButtons.removeAll(keepingCapacity: true)
			
			score += 1
			
			if score % 7 == 0 {
				let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
				present(ac, animated: true)
			}
			
		} else {
			score -= 1
			let animations = { [self] in
				UIView.addKeyframe(withRelativeStartTime: 0.0/3.0, relativeDuration: 1.0/3.0) {
					currentAnswer.transform = CGAffineTransform(translationX: 20, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 1.0/3.0, relativeDuration: 1.0/3.0) {
					currentAnswer.transform = CGAffineTransform(translationX: -20, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 2.0/3.0, relativeDuration: 1.0/3.0) {
					currentAnswer.transform = CGAffineTransform.identity
				}
			}
			
			UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModePaced, animations: animations) { [self]_ in
				currentAnswer.layer.borderWidth = 1
				currentAnswer.layer.borderColor = UIColor.red.cgColor
				submitButton.isEnabled = false
			}
		}
		
	}
	
	@objc func clearTapped(_ sender: UIButton) {
		currentAnswer.text = ""
		
		for button in activatedButtons {
			button.isHidden = false
		}
		activatedButtons.removeAll()
	}
	
	// MARK: - Utility Methods
	
	func loadLevel() {
		var clueString = ""
		var solutionString = ""
		var letterBits = [String]()
		
		if let levelFileUrl = Bundle.main.url(forResource: "level1", withExtension: "txt") {
			if let levelContents = try? String(contentsOf: levelFileUrl) {
				var lines = levelContents.components(separatedBy: .newlines)
				lines.shuffle()
				
				for (index, line) in lines.enumerated() {
					let parts = line.components(separatedBy: ": ")
					let answer = parts[0]
					let clue = parts[1]
					
					clueString.append("\(index + 1). \(clue)\n")
					
					let solutionWord = answer.replacingOccurrences(of: "|", with: "")
					solutionString.append("\(solutionWord.count) letters\n")
					solutions.append(solutionWord)
					
					let bits = answer.components(separatedBy: "|")
					letterBits += bits
				}
				
				cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
				answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
			}
		}
		
		letterBits.shuffle()
		if letterButtons.count == letterBits.count {
			for i in 0 ..< letterButtons.count {
				letterButtons[i].setTitle(letterBits[i], for: .normal)
			}
		}
	}
	
	@objc func levelUp(action: UIAlertAction) {
		solutions.removeAll(keepingCapacity: true)
		
		level += 1
		loadLevel()
		
		for btn in letterButtons {
			btn.isHidden = false
		}
	}
	
	func updateScoreLabel() {
		let animations = { [self] in
			scoreLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
			
			if score > scoreBefore {
				scoreLabel.textColor = .green
			} else {
				scoreLabel.textColor = .red
			}
		}
		
		UIView.animate(withDuration: 0.2, delay: 0.1, animations: animations) { [self] (finished: Bool) -> Void in
			scoreLabel.text = "Score: \(score)"
			UIView.animate(withDuration: 0.25, animations: { () -> Void in
				self.scoreLabel.transform = CGAffineTransform.identity
				scoreLabel.textColor = .black
			})
		}
	}
	
}

