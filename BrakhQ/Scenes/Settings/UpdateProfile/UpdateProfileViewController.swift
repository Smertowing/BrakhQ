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
		hideKeyboardWhenTappedAround()
		title = "Update Profile".localized
		self.navigationController?.title = nil
		
		setupViewModel()
		initializeForm()
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	private func initializeForm() {
		form
			
			+++
			Section("Change Profile".localized)
			<<< TextRow("Name") {
				$0.title = $0.tag?.localized
				$0.value = AuthManager.shared.user?.name
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
			}
			
			<<< EmailRow("Email") {
				$0.title = $0.tag?.localized
				$0.value = AuthManager.shared.user?.email
				
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
				row.title = "Save".localized
				}.onCellSelection { (cell, row) in
					let emailRow: EmailRow! = self.form.rowBy(tag: "Email")
					let nameRow: TextRow! = self.form.rowBy(tag: "Name")
					if emailRow.validate().isEmpty && nameRow.validate().isEmpty {
						self.viewModel.changeProfile(name: nameRow.value!, email: emailRow.value!)
					}
				
			}
	
		form
			+++
			Section(header: "Change Password".localized, footer: "Length must be greater than 6".localized)
			/*
			<<< PasswordRow("Current password") {
				$0.title = $0.tag
				$0.add(rule: RuleRequired())
				$0.add(rule: RuleMinLength(minLength: 6))
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			*/
			<<< PasswordRow("New password") {
				$0.placeholder = $0.tag?.localized
				$0.add(rule: RuleRequired())
				$0.add(rule: RuleMinLength(minLength: 6))
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			
			<<< PasswordRow("Confirm new password") {
				$0.placeholder = $0.tag?.localized
				$0.add(rule: RuleRequired())
				$0.add(rule: RuleEqualsToRow(form: form, tag: "New password"))
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			
			+++
			Section()
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Submit New Password".localized
				}
				.onCellSelection { (cell, row) in
					//let currentRow: PasswordRow! = self.form.rowBy(tag: "Current password")
					let newRow: PasswordRow! = self.form.rowBy(tag: "New password")
					let confirmRow: PasswordRow! = self.form.rowBy(tag: "Confirm new password")
					if newRow.validate().isEmpty && confirmRow.validate().isEmpty {
						self.viewModel.updatePassword(password: newRow.value!)
					}
				}
				.cellSetup { (cell, row) in
					cell.tintColor = .red
		}
	}
	
}

extension UpdateProfileViewController: UpdateProfileViewModelDelegate {
	
	func updateProfileViewModel(_ updateProfileViewModel: UpdateProfileViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func updateProfileViewModel(_ updateProfileViewModel: UpdateProfileViewModel, updateSuccessfull: Bool) {
		
		if updateSuccessfull {
			let alert = UIAlertController(title: "Successfull".localized, message: "You've updated account".localized, preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default))
			self.present(alert, animated: true, completion: nil)
		} else {
			let alert = UIAlertController(title: "Failure".localized, message: "There was an error", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.destructive))
			self.present(alert, animated: true, completion: nil)
		}
		
	}
	
	
}
