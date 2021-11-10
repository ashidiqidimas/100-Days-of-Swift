//
//  CollectionViewCell.swift
//  project13
//
//  Created by Dimas on 14/10/21.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "FilterCollectionViewCell"
	var filter = ""
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleToFill
		
		return imageView
	}()
	
	let title: UILabel = {
		let title = UILabel()
		title.translatesAutoresizingMaskIntoConstraints = false
		title.font = .systemFont(ofSize: 13)
		title.numberOfLines = 2
		title.text = "Twirl Distortion"
		return title
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	func setup() {
//		backgroundColor = .lightGray
		
		self.addSubview(imageView)
		self.addSubview(title)
		
		imageView.layer.cornerRadius = 8

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: self.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -4),
			imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			imageView.heightAnchor.constraint(equalToConstant: 80),
			
//			title.topAnchor.constraint(equalTo: imageView.bottomAnchor),
			title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
			title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 2)
		])
		
	}

}
