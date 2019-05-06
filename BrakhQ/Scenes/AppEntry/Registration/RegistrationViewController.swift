//
//  RegistrationViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

class RegistrationViewController: FormViewController {

	private let viewModel: RegistrationViewModel
	
	init(viewModel: RegistrationViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "Edit Queue"
		self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(self.registerButtonClicked)), animated: false)
		
		setupViewModel()
		initializeForm()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	private func initializeForm() {
		form
			
			+++
			Section("Change Profile")
			<<< NameRow("Username") {
				$0.title = $0.tag
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
				}
			}
			
			<<< NameRow("Name") {
				$0.title = $0.tag
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
				}
			}
			
			<<< EmailRow("Email") {
				$0.title = $0.tag
				$0.add(rule: RuleRequired())
				var ruleSet = RuleSet<String>()
				ruleSet.add(rule: RuleRequired())
				ruleSet.add(rule: RuleEmail())
				$0.add(ruleSet: ruleSet)
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
				}
			}
		
			+++
			Section(header: "Create Password", footer: "Length must be greater than 6")
			
			<<< PasswordRow("New password") {
				$0.title = $0.tag
				$0.add(rule: RuleRequired())
				$0.add(rule: RuleMinLength(minLength: 6))
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
				}
			}
			
			<<< PasswordRow("Confirm new password") {
				$0.title = $0.tag
				$0.add(rule: RuleRequired())
				$0.add(rule: RuleEqualsToRow(form: form, tag: "New password"))
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
				}
			}
			
			+++
			Section()
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Register"
				}.onCellSelection { [weak self] (cell, row) in
					self?.registerButtonClicked()
			}
	}
	
	@objc func registerButtonClicked() {
		if form.validate().isEmpty {
			let usernameRow: NameRow! = form.rowBy(tag: "Username")
			let passwordRow: PasswordRow! = form.rowBy(tag: "New password")
			let emailRow: EmailRow! = form.rowBy(tag: "Email")
			let nameRow: NameRow! = form.rowBy(tag: "Name")
			viewModel.register(username: usernameRow.value!,
												 password: passwordRow.value!,
												 email: emailRow.value!,
												 name: nameRow.value!)
		}
	}
	
}

extension RegistrationViewController: RegistrationViewModelDelegate {
	
	func registrationViewModel(_ registrationViewModel: RegistrationViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func registrationViewModel(_ registrationViewModel: RegistrationViewModel, isSuccess: Bool, didRecieveMessage message: ResponseStateRegistration?) {
		if isSuccess {
			if message!.success {
				
				let alert = UIAlertController(title: "Successfull", message: "You've created account!", preferredStyle: UIAlertController.Style.alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
					_ = self.navigationController?.popViewController(animated: true)
				})
				self.present(alert, animated: true, completion: nil)
				
			} else {
				showErrorAlert(errorsLog: message!.errors)
			}
		} else {
			showErrorAlert(errorsLog: ["Error:":"Internet connection failure"])
		}
	}
	
}
