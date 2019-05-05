//
//  SiteTableViewCell.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class SiteTableViewCell: UITableViewCell {
	
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var actionButtom: UIButton!
	
	@IBAction func actionButtonClicked(_ sender: Any) {
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
