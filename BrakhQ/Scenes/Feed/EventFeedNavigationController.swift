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
		let viewModel = EventFeedViewModel()
		self.pushViewController(EventFeedViewController(viewModel: viewModel), animated: false)
	}
	
}
