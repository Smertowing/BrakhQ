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
		
		setupViewModel()
	}

	@IBAction func signinClicked(_ sender: Any) {
		if let username = loginField.text, let password = passwordField.text {
			if (username.trimmingCharacters(in: .whitespacesAndNewlines) != "") && (password.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
				viewModel.login(username: username, password: password)
			}
		}
	}
	
	@IBAction func returnClicked(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
}

extension LoginViewController: LoginViewModelDelegate {
	
	func loginViewModel(_ loginViewModel: LoginViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func loginViewModel(_ loginViewModel: LoginViewModel, isSuccess: Bool, user: User?) {
		if isSuccess {
			let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "mainTabVC")
			self.present(mainViewController, animated: true, completion: nil)
		} else {
			let alert = UIAlertController(title: "Failure".localized, message: "There was an error".localized, preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default))
			self.present(alert, animated: true, completion: nil)
		}
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
