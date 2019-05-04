//
//  EventCalendarNavigationController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class EventCalendarNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let viewModel = EventCalendarViewModel()

		self.pushViewController(EventCalendarViewController(viewModel: viewModel), animated: false)
	}
	
}
