//
//  EventTableViewCell.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
	
	@IBOutlet weak var typeImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var eventDateLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var statusImageView: UIImageView!
	@IBOutlet weak var counterLabel: UILabel!
	@IBOutlet weak var userConditionLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

	// Configure the view for the selected state
	}

}
