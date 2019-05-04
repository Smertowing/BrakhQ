//
//  StartViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

	private let viewModel: StartViewModel
	
	init(viewModel: StartViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func login(_ sender: Any) {
		
	}
	
	@IBAction func signup(_ sender: Any) {
	}
	
}
