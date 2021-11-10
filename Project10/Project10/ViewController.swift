//
//  ViewController.swift
//  Project10
//
//  Created by Dimas on 07/09/21.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var people = [Person]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Collections"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
	}
	
	// MARK: UIImagePickerControllerDelegate
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCollectionViewCell else { fatalError("Unable to deque reusable cell") }
		
		let person = people[indexPath.item]
		
		let path = getDocumentsDirectory().appendingPathComponent(person.imageString, isDirectory: true)
		cell.imageView.image = UIImage(contentsOfFile: path.path)
		cell.name.text = person.name

		cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 7
		cell.layer.cornerRadius = 7
		return cell
	}
	
	@objc func addNewPerson() {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
		
		present(imagePicker, animated: true)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]
		
		let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
			guard let text = ac?.textFields?[0].text else { return }
			person.name = text
			
			self?.collectionView.reloadItems(at: [indexPath])
		})
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		present(ac, animated: true)
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName, isDirectory: true)

		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		let person = Person(name: "Unknown", imageString: imageName)
		people.append(person)
		collectionView.reloadData()
		
		dismiss(animated: true)
	}
	
	func getDocumentsDirectory() -> URL {
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return path[0]
	}
}

