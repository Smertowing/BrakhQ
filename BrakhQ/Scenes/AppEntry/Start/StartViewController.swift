//
//  StartViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

class StartViewController: UIViewController {

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		hideKeyboardWhenTappedAround()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}

	@IBAction func login(_ sender: Any) {
		let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
		loginViewController.viewModel = LoginViewModel()
		self.show(loginViewController, sender: self)
	}
	
	@IBAction func loginViaVK(_ sender: Any) {
		let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "vkLogin") as! VKLoginViewController
		self.show(loginViewController, sender: self)
	}
	
	@IBAction func signup(_ sender: Any) {
		let viewModel = RegistrationViewModel()
		self.show(RegistrationViewController(viewModel: viewModel), sender: self)
	}
	
}
