//
//  SiteTableViewCell.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

enum SiteActionButtonText: String {
	case release = "Release"
	case engaged = "Engaged"
	case free = "Take"
}

struct SiteConfig {
	
	var accessability: SiteActionButtonText
	var username: String
	var position: Int
	var interactable: Bool
	
}


class SiteTableViewCell: UITableViewCell {
	
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var actionButtom: UIButton!
	
	weak var viewModel: EventViewModel!
	var config: SiteConfig!
	
	@IBAction func actionButtonClicked(_ sender: Any) {
		viewModel.interactPlace(config.position)
	}
	
	func set(config: SiteConfig) {
		self.config = config
		numberLabel.text = "\(config.position)."
		nameLabel.text = config.username
		switch config.accessability {
		case .release:
			backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
		case .engaged:
			backgroundColor = #colorLiteral(red: 0.9480290292, green: 0.580959484, blue: 0.7219921503, alpha: 1)
		case .free:
			backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
		}
		actionButtom.setTitle(config.accessability.rawValue.localized, for: .normal)
		actionButtom.isHidden = !config.interactable
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
