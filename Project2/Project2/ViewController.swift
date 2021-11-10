//
//  ViewController.swift
//  Project2
//
//  Created by Dimas on 06/08/21.
//

import UIKit

class ViewController: UIViewController {
	
	
	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!
	
	var countries = [String]()
	var score = 0
	var correctAnswer = 0
	var questionNumber = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		countries += ["Estonia", "France", "Germany", "Ireland", "Italy",
					  "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
		
		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1
		
		button1.layer.borderColor = UIColor.lightGray.cgColor
		button2.layer.borderColor = UIColor.lightGray.cgColor
		button3.layer.borderColor = UIColor.lightGray.cgColor
		
		button1.layer.cornerRadius = 10
		button2.layer.cornerRadius = 10
		button3.layer.cornerRadius = 10
		
		button1.imageView?.layer.cornerRadius = 10
		button2.imageView?.layer.cornerRadius = 10
		button3.imageView?.layer.cornerRadius = 10
		
		askQuestion()
	}
	
	@IBAction func flagTapped(_ sender: UIButton) {
		var alertTitle: String
		var actionTitle: String
		var message: String
		var isRestart = false
		
		if sender.tag == correctAnswer {
			alertTitle = "Correct"
			score += 1
			message = "Your score is \(score)"
		} else {
			alertTitle = "Wrong"
			score -= 1
			message = "That's the flag of \(countries[sender.tag].uppercased())\nYour score is \(score)"
		}
		
		if questionNumber != 3 {
			actionTitle = "Continue"
		} else {
			alertTitle = "Game Over"
			actionTitle = "Restart"
			isRestart = true
		}
		
		let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: actionTitle, style: .default, handler: askQuestion)
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
		
		if isRestart {
			self.score = 0
			self.correctAnswer = 0
			self.questionNumber = 1
		}
		questionNumber += 1
	}
	
	
	func askQuestion(action: UIAlertAction? = nil) {
		countries.shuffle()
		
		correctAnswer = Int.random(in: 0...2)
		self.title = "\(countries[correctAnswer].uppercased()), Score: \(score)"
		
		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)
		
		print(countries[0], countries[1], countries[2])
	}
	
}

