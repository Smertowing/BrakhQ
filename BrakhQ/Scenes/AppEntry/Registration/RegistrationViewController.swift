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
		
		initializeForm()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	private func initializeForm() {
		form
			
			+++
			Section("Change Profile")
			<<< NameRow() {
				$0.title = "Username"
			}
			
			<<< NameRow() {
				$0.title = "Name"
			}
			
			<<< EmailRow() {
				$0.title = "Email"
				
				$0.add(rule: RuleRequired())
				var ruleSet = RuleSet<String>()
				ruleSet.add(rule: RuleRequired())
				ruleSet.add(rule: RuleEmail())
				$0.add(ruleSet: ruleSet)
				$0.validationOptions = .validatesOnChangeAfterBlurred
			}
		
			+++
			Section(header: "Create Password", footer: "Length must be greater than 6")
			
			<<< PasswordRow("new_password") {
				$0.title = "New password"
				
				$0.add(rule: RuleMinLength(minLength: 6))
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			
			<<< PasswordRow("confirm_password") {
				$0.title = "Confirm new password"
				
				$0.add(rule: RuleEqualsToRow(form: form, tag: "new_password"))
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
		
	}
	
}
