//
//  UpdateProfileViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

class UpdateProfileViewController: FormViewController {

	private let viewModel: UpdateProfileViewModel

	init(viewModel: UpdateProfileViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Update Profile"
		self.navigationController?.title = nil
		form
			
			+++
			Section("Change Profile")
			
			<<< NameRow() {
				$0.title = "Name:"
				$0.value = "Kira Holubeu"
			}
			
			<<< EmailRow() {
				$0.title = "Email:"
				$0.value = "kiryla.go@gmail.com"
				
				$0.add(rule: RuleRequired())
				var ruleSet = RuleSet<String>()
				ruleSet.add(rule: RuleRequired())
				ruleSet.add(rule: RuleEmail())
				$0.add(ruleSet: ruleSet)
				$0.validationOptions = .validatesOnChangeAfterBlurred
			}
			
			+++
			Section()
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Save"
				}.onCellSelection { [weak self] (cell, row) in
					
				}
			
			+++
			Section(header: "Change Password", footer: "Length must be from 8 to 13")
			
			<<< PasswordRow() {
				$0.title = "Current password:"
				$0.add(rule: RuleMinLength(minLength: 8))
				$0.add(rule: RuleMaxLength(maxLength: 13))
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
				}
			
			<<< PasswordRow("new_password") {
				$0.title = "New password:"
				
				$0.add(rule: RuleMinLength(minLength: 8))
				$0.add(rule: RuleMaxLength(maxLength: 13))
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
				}
			
			<<< PasswordRow("confirm_password") {
				$0.title = "Confirm new password:"
				
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
				row.title = "Submit New Password"
				}
				.onCellSelection { [weak self] (cell, row) in
					
				}
				.cellSetup { (cell, row) in
					cell.tintColor = .red
				}
	}
	
}
