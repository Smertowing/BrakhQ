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
		//title = "Register".localized
		self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Register".localized, style: .done, target: self, action: #selector(self.registerButtonClicked)), animated: false)
		
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
			Section("Change Profile".localized)
			<<< TextRow("Username") {
				$0.title = $0.tag?.localized
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
				}
			}
			
			<<< TextRow("Name") {
				$0.title = $0.tag?.localized
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
				}
			}
			
			<<< EmailRow("Email") {
				$0.title = $0.tag?.localized
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
			Section(header: "Create Password".localized, footer: "Length must be greater than 6".localized)
			
			<<< PasswordRow("New password") {
				$0.title = $0.tag?.localized
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
				$0.title = $0.tag?.localized
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
				row.title = "Register".localized
				}.onCellSelection { (cell, row) in
					self.registerButtonClicked()
			}
	}
	
	@objc func registerButtonClicked() {
		if form.validate().isEmpty {
			let usernameRow: TextRow! = form.rowBy(tag: "Username")
			let passwordRow: PasswordRow! = form.rowBy(tag: "New password")
			let emailRow: EmailRow! = form.rowBy(tag: "Email")
			let nameRow: TextRow! = form.rowBy(tag: "Name")
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
	
	func registrationViewModel(_ registrationViewModel: RegistrationViewModel, isSuccess: Bool, didRecieveMessage error: NetworkError!) {
		if isSuccess {
			showAlert(title: "Successfull".localized, message: "You've created account".localized) {
				_ = self.navigationController?.popViewController(animated: true)
			}
		} else {
			showErrorAlert(error)
		}
	}
	
}
