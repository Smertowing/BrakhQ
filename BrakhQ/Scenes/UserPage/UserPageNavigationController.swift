//
//  UserPageNavigationController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class UserPageNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let storyBoard = UIStoryboard(name: "UserPage", bundle: nil)
		let userPageViewController = storyBoard.instantiateViewController(withIdentifier: "userPageViewController") 
		self.pushViewController(userPageViewController, animated: false)
	}

}
