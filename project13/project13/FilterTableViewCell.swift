//
//  FilterTableViewCell.swift
//  project13
//
//  Created by Dimas on 19/10/21.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
	
	static let identifier = "FilterTableViewCell"
	var key = ""
	
	let label: UILabel = {
		let label = UILabel()
	
		return label
	}()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
