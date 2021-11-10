//
//  CustomTableViewCell.swift
//  Milestone Project 1-3
//
//  Created by Dimas on 11/08/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
	
	@IBOutlet weak var countryImageView: UIImageView!
	@IBOutlet weak var countryLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		countryImageView.layer.borderWidth = 1
		countryImageView.layer.borderColor = UIColor.lightGray.cgColor
		countryImageView.layer.cornerRadius = 6
		
		contentView.layer.cornerRadius = 10
		contentView.layer.masksToBounds = true
		self.selectionStyle = .none
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
		
		if selected {
			contentView.backgroundColor = UIColor(red: 0.863, green: 0.863, blue: 0.863, alpha: 1.0) // equals to #DCDCDC
		} else {
			contentView.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.0) // equals to #F0F0F0
		}
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		//set the values for top,left,bottom,right margins
		let margins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
		contentView.frame = contentView.frame.inset(by: margins)
		
	}
	
}
