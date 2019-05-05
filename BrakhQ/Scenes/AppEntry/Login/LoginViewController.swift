//
//  LoginViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	var viewModel: LoginViewModel!
	
	@IBOutlet weak var bottomOffset: NSLayoutConstraint!
	@IBOutlet weak var topOffset: NSLayoutConstraint!
	
	@IBOutlet weak var loginField: UITextField!
	@IBOutlet weak var passwordField: UITextField!

	@IBOutlet weak var signinButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@IBAction func signinClicked(_ sender: Any) {
		let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "mainTabVC")
		self.present(mainViewController, animated: true, completion: nil)
	}
	
	@IBAction func returnClicked(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
}

extension LoginViewController  {
	
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			
			bottomOffset.constant = -keyboardSize.height
			topOffset.constant = -keyboardSize.height
			UIView.animate(withDuration: 0.3) {
				self.view.layoutIfNeeded()
			}
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		bottomOffset.constant = 0
		topOffset.constant = 0
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
	
}
