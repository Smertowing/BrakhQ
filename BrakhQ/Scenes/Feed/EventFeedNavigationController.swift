//
//  EventFeedNavigationController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class EventFeedNavigationController: UINavigationController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let storyBoard = UIStoryboard(name: "EventFeed", bundle: nil)
		let eventFeedViewController = storyBoard.instantiateViewController(withIdentifier: "eventFeedViewController")
		self.pushViewController(eventFeedViewController, animated: false)
	}
	
}
