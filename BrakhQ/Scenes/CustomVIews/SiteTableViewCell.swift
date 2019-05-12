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
	
	weak var viewModel: EventViewModel!
	var position: Int!
	
	@IBAction func actionButtonClicked(_ sender: Any) {
		viewModel.interactPlace(position)
	}
	
	func set(user: UserCashe?, to position: Int, interactable: Bool) {
		self.position = position
		numberLabel.text = "\(position)."
		if let user = user {
			nameLabel.text = user.name
			if user.id == AuthManager.shared.user?.id {
				backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
				actionButtom.setTitle("Release", for: .normal)
			} else {
				backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
				actionButtom.setTitle("Engaged", for: .normal)
			}
		} else {
			backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
			nameLabel.text = "Free"
			actionButtom.setTitle("Take", for: .normal)
		}
		actionButtom.isHidden = !interactable
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
