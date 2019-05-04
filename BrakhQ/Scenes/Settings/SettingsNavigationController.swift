//
//  SettingsNavigationController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class SettingsNavigationController: UINavigationController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let viewModel = EventCalendarViewModel()
		self.pushViewController(EventCalendarViewController(viewModel: viewModel), animated: false)
	}
	
}

