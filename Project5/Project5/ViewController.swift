//
//  ViewController.swift
//  Project5
//
//  Created by Dimas on 16/08/21.
//

import UIKit

class ViewController: UITableViewController {
	
	var allWords = [String]()
	var usedWords = [String]()
	var errorsMessage = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "\n")
			}
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		
		start()
	}
	
	@objc func start(action: UIAlertAction! = nil) {
		title = allWords.randomElement()
		usedWords.removeAll(keepingCapacity: true)
		tableView.reloadData()

		navigationItem.setLeftBarButton(nil, animated: true)
	}
	
	@objc func restart() {
		let ac = UIAlertController(title: "Your score is \(usedWords.count) words", message: nil, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Okay", style: .default,handler: start))
		present(ac, animated: true, completion: nil)
	}
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitAnswer = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
			if let answer = ac?.textFields?[0].text {
				self?.submit(answer.lowercased())
			}
		}
		
		ac.addAction(submitAnswer)
		present(ac, animated: true)
	}
	
	func submit(_ answer: String) {
		
		let wordIsPossible = isPossible(word: answer)
		let wordIsOriginal = isOriginal(word: answer)
		let wordIsReal = isReal(word: answer)
		let wordIsDifferent = isTheStartWord(word: answer)
		let wordHasThreeLetters = isMoreThanTwo(word: answer)
		
		if wordIsPossible && wordIsOriginal && wordIsReal && wordIsDifferent && wordHasThreeLetters {
			usedWords.insert(answer, at: 0)
			
			let indexPath = IndexPath(row: 0, section: 0)
			tableView.insertRows(at: [indexPath], with: .automatic)
			
			if usedWords.count > 0 {
				let restartBtn = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(restart))
				navigationItem.setLeftBarButton(restartBtn, animated: true)
			}
		} else {
			
			let message = "\(answer) is \(getMessage())"
			let ac = UIAlertController(title: "You can't use that:(", message: message, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Okay", style: .default))
			present(ac, animated: true)
			
			errorsMessage.removeAll(keepingCapacity: true)
		}
	}
	
	func getMessage() -> String {
		var result = ""
		
		if errorsMessage.count > 2 {
			for i in 0 ..< errorsMessage.count - 1 {
				result.append("\(errorsMessage[i]), ")
			}
			result.append("and \(errorsMessage.last!).")
			
		} else if errorsMessage.count == 2 {
			result = "\(errorsMessage[0]) and \(errorsMessage[1])."
			
		} else {
			result = "\(errorsMessage[0])."
		}
		
		return result
	}
	
	func isPossible(word: String) -> Bool {
		guard var targetWord = title?.lowercased() else { return false }

		for letter in word {
			if let position = targetWord.firstIndex(of: letter) {
				targetWord.remove(at: position)
			} else {
				errorsMessage.append("not an anagram of \(title!)")
				return false
			}
		}
		
		return true
	}
	
	func isMoreThanTwo(word answer: String) -> Bool {
		if answer.count > 2 {
			return true
		} else {
			errorsMessage.append("shorther than three letters")
			return false
		}
	}
	
	func isTheStartWord(word answer: String) -> Bool {
		if answer == title?.lowercased() {
			errorsMessage.append("same with the start word")
			return false
		} else {
			return true
		}
	}
	
	func isOriginal(word: String) -> Bool {
		if usedWords.contains(word.lowercased()) {
			errorsMessage.append("already used")
			return false
		} else {
			return true
		}
	}
	
	func isReal(word: String) -> Bool {
		let cheker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = cheker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		
		if misspelledRange.location == NSNotFound {
			return true
		} else {
			errorsMessage.append("not an english word")
			return false
		}
	}
	
	// MARK: - UITableViewDataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usedWords.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		
		return cell
	}
}
