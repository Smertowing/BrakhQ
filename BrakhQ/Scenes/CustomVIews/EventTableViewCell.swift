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
	
	var currentQueue: QueueCashe!
	
	func setQueue(_ queue: QueueCashe) {
		
		currentQueue = queue
		nameLabel.text = queue.name
		eventDateLabel.text = queue.eventDate.displayDate
		counterLabel.text = "\(queue.busyPlaces.count)/\(queue.placesCount)"
		
		if queue.regActive {
			statusLabel.text = "Active"
			typeImageView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
			statusImageView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
		} else if queue.regEnded {
			statusLabel.text = "Ended"
			typeImageView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
			statusImageView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
		} else {
			statusLabel.text = "Expected"
			typeImageView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
			statusImageView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
			counterLabel.isHidden = true
		}
	/*
		if queue.owner.id == AuthManager.shared.user?.id {
			userConditionLabel.text = "Owner"
		} else {
			userConditionLabel.text = ""
		}
	*/
		if queue.owner.id == AuthManager.shared.user?.id {
			typeImageView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
		} else {
			typeImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		}
		
		statusImageView.layer.cornerRadius = statusImageView.layer.width/2
		typeImageView.isHidden = false
		
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
