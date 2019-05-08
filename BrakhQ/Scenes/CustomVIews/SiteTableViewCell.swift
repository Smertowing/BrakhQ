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
	
	func set(user: UserCashe?, to position: Int) {
		numberLabel.text = "\(position)."
		if let user = user {
			nameLabel.text = user.name
			if user.id == AuthManager.shared.user?.id {
				backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
				actionButtom.titleLabel?.text = "Release"
			} else {
				backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
				actionButtom.titleLabel?.text = "Engaged"
			}
		} else {
			backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
			nameLabel.text = "Free"
		}
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
