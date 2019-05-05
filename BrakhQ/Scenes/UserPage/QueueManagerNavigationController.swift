//
//  QueueManagerNavigationController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class QueueManagerNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let storyBoard = UIStoryboard(name: "QueueManager", bundle: nil)
		let queueManagerViewController = storyBoard.instantiateViewController(withIdentifier: "queueManagerViewController")
		self.pushViewController(queueManagerViewController, animated: false)
	}

}
