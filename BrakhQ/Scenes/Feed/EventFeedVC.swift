//
//  EventFeedViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

class EventFeedViewController: UIViewController {

	private let viewModel: EventFeedViewModel

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	init(viewModel: EventFeedViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
}
