//
//  LoginViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	private let viewModel: LoginViewModel
	
	init(viewModel: LoginViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@IBOutlet weak var loginField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	@IBOutlet private weak var indicatorView: UIActivityIndicatorView!
	@IBOutlet weak var signinButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
	}

}

