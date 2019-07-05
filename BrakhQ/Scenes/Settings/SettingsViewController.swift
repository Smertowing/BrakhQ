//
//  SettingsViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

	private let viewModel: SettingsViewModel

	init(viewModel: SettingsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "Settings".localized
		self.navigationController?.title = nil
		navigationController?.navigationBar.isTranslucent = false
		tabBarController?.tabBar.isTranslucent = false
		
		setupViewModel()
		initializeForm()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateFormValues()
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	private func updateFormValues() {
		DispatchQueue.main.async() {
			let name: LabelRow! = self.form.rowBy(tag: "Name")
			name.updateCell()
			let email: LabelRow! = self.form.rowBy(tag: "Email")
			email.updateCell()
		}
	}

	private func initializeForm() {
		form
			+++
			Section("My Profile".localized) {
				$0.header = HeaderFooterView<BrakhQLogoView>(.class)
			}
			<<< LabelRow("Username") {
				$0.title = $0.tag?.localized
				$0.value = AuthManager.shared.user?.username
			}
			
			<<< LabelRow("Name") {
				$0.title = $0.tag?.localized
				$0.value = AuthManager.shared.user?.name
				}.cellUpdate {_, row in
					row.value = AuthManager.shared.user?.name
			}
			
			<<< LabelRow("Email") {
				$0.title = $0.tag?.localized
				$0.value = AuthManager.shared.user?.email
				}.cellUpdate {_, row in
					row.value = AuthManager.shared.user?.email
			}
			
			<<< ButtonRow("Update profile") { (row: ButtonRow) -> Void in
				row.title = row.tag?.localized
				row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: viewModel.getUpdateViewController), onDismiss: nil)
			}
			
		form
		
			/*
			+++
			Section("Application Settings".localized)
			
			<<< PickerInlineRow<String>("Appearance".localized) { (row : PickerInlineRow<String>) -> Void in
				row.title = row.tag?.localized
				row.displayValueFor = { (rowValue: String?) in
					return rowValue.map { (rowValue: String?) in
						"\(rowValue ?? "Error")"
					}
				}
				row.options = ["Light".localized, "Dark".localized]
				row.value = row.options[0]
			}
			*/
			
			+++
			Section()
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Open in Settings".localized
				}.onCellSelection({ (cell, row) in
					self.notificationClicked()
				})
			
			+++
			Section()
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Log Out".localized
				}.onCellSelection { (cell, row) in
					self.exitButtonClicked()
				}.cellSetup { (cell, row) in
					cell.tintColor = .red
		}
	}
	
	@objc func notificationClicked() {
		if let appSettings = URL(string: UIApplication.openSettingsURLString) {
			UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
		}
	}

	@objc func exitButtonClicked() {
		let alert = UIAlertController(title: "Exit".localized, message: "Do you really want to exit your account?".localized, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { action in
			self.viewModel.exit()
		}))
		self.present(alert, animated: true)
	}
}

extension SettingsViewController: SettingsViewModelDelegate {
	
	func settingsViewModel(_ settingsViewModel: SettingsViewModel, readyToExit: Bool) {
		if readyToExit {
			self.segueToStartScreen()
		}
	}
	
}
