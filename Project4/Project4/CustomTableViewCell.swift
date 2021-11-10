//
//  CustomTableViewCell.swift
//  Project4
//
//  Created by Dimas on 15/08/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

	@IBOutlet weak var websiteLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		contentView.layer.cornerRadius = 10
		contentView.layer.masksToBounds = true
		self.selectionStyle = .none	// disable the default selection effect
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		if selected {
			contentView.backgroundColor = UIColor(red: 0.863, green: 0.863, blue: 0.863, alpha: 1.0) // equals to #DCDCDC
		} else {
			contentView.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.0) // equals to #F0F0F0
		}
		
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// set the values for top, left, bottom, right margins
		let margins = UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
		contentView.frame = contentView.frame.inset(by: margins)
	}
    
}
