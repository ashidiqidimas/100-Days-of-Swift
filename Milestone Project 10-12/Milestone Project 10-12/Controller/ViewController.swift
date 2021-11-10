//
//  ViewController.swift
//  Milestone Project 10-12
//
//  Created by Dimas on 03/10/21.
//

import UIKit

class ViewController: UIViewController {
	
	var images: [Image]!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		customizeTabBar()
	}
	
	func customizeTabBar() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addPhoto))
	}
	
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@objc func addPhoto() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .photoLibrary
		present(picker, animated: true)
		
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { fatalError() }
		dismiss(animated: true)
		
		let ac = UIAlertController(title: "Choose Caption", message: "blabla", preferredStyle: .alert)
		ac.addTextField() { textfield in
			textfield.placeholder = "Enter a caption"
		}

		let submit = UIAlertAction(title: "Submit", style: .default) { _ in
			let textfield = ac.textFields?.first
			print(textfield?.text as Any)
		}
		
		ac.addAction(submit)
		present(ac, animated: true)
	}
}

