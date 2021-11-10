//
//  ViewController.swift
//  Project10New
//
//  Created by Dimas on 19/09/21.
//

import UIKit

class ViewController: UICollectionViewController {
	
	var people = [Person]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.hidesBarsOnSwipe = true
		
		configureUI()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
	}
	
	@objc func addPerson() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true)
	}

	func configureUI() {
		configureCollectionView()
		
		navigationController?.navigationBar.barTintColor = .init(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
		navigationController?.navigationBar.shadowImage = UIImage()
//		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.layoutIfNeeded()
		
	}
	
	func configureCollectionView() {
		collectionView.backgroundColor = .init(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
		collectionView.contentInset = .init(top: 16, left: 24, bottom: 16, right: 24)
		
		let cellWidth = (view.frame.width - 80) / 3
		let cellHeight = cellWidth * 4 / 3
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = .init(width: cellWidth, height: cellHeight)
		layout.minimumInteritemSpacing = 16
		layout.minimumLineSpacing = 16
		
		collectionView.collectionViewLayout = layout
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		
		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		collectionView.reloadData()

		dismiss(animated: true)
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}

extension ViewController {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCollectionViewCell else {
			fatalError("Can't deque cell")
		}
		
		cell.backgroundColor = .white
		cell.layer.borderWidth = 1
		cell.layer.borderColor = UIColor(white: 0, alpha: 0.15).cgColor
		cell.layer.cornerRadius = 8
		
		let person = people[indexPath.item]
		let path = getDocumentsDirectory().appendingPathComponent(person.image)
		cell.imageView.image = UIImage(contentsOfFile: path.path)
		cell.name.text = person.name

		return cell
	}
}

