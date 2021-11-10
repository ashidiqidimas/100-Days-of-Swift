//
//  CountryTableViewCell.swift
//  Milestone Project 13-15
//
//  Created by Dimas on 23/10/21.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
	static let identidier = "CountryTableViewCell"

	let flagImageView: COImageView = {
		let flagImageView = COImageView()
		flagImageView.translatesAutoresizingMaskIntoConstraints = false
		flagImageView.backgroundColor = .gray
		flagImageView.contentMode = .scaleAspectFill
		flagImageView.layer.cornerRadius = 8
		flagImageView.layer.masksToBounds = true
		flagImageView.isSkeletonable = true
		
		return flagImageView
	}()
	
	let countryLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Country Name"
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		contentView.addSubview(flagImageView)
		contentView.addSubview(countryLabel)
		
		configureCell()
		configureConstraints()
	
	}
	
	func configureCell() {
		contentView.backgroundColor = .init("#F0F0F0")
		let margins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
		contentView.frame = contentView.frame.inset(by: margins)
		contentView.layer.cornerRadius = 10
		selectionStyle = .none
		
	}
	
	func configureConstraints() {
		NSLayoutConstraint.activate([
			flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			flagImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor, multiplier: 3/2),
			
			countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
		])
	}
	
}
