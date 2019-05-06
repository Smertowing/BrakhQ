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
		title = "Settings"
		self.navigationController?.title = nil
		navigationController?.navigationBar.isTranslucent = false
		tabBarController?.tabBar.isTranslucent = false
		
		setupViewModel()
		initializeForm()
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}

	private func initializeForm() {
		form
			+++
			Section("My Profile") {
				$0.header = HeaderFooterView<BrakhQLogoView>(.class)
			}
			<<< LabelRow() {
				$0.title = "Username"
				$0.value = "Smertowing"
			}
			
			<<< LabelRow() {
				$0.title = "Name"
				$0.value = "Kiryl Holubeu"
			}
			
			<<< LabelRow() {
				$0.title = "Email"
				$0.value = "kiryla.go@gmail.com"
			}
			
			<<< ButtonRow("Update profile") { (row: ButtonRow) -> Void in
				row.title = row.tag
				row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: viewModel.getUpdateViewController), onDismiss: nil)
			}
			
		form
			+++
			Section("Application Settings")
			
			<<< PickerInlineRow<String>("Appearance") { (row : PickerInlineRow<String>) -> Void in
				row.title = row.tag
				row.displayValueFor = { (rowValue: String?) in
					return rowValue.map { (rowValue: String?) in
						"\(rowValue ?? "Error")"
					}
				}
				row.options = ["Light", "Dark"]
				row.value = row.options[0]
			}
			
			+++
			Section()
			
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Log Out"
				}.onCellSelection { [weak self] (cell, row) in
					self?.exitButtonClicked()
				}.cellSetup { (cell, row) in
					cell.tintColor = .red
		}
	}
	
	@IBAction func showAlert() {
		let alertController = UIAlertController(title: "OnCellSelection", message: "Button Row Action", preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(defaultAction)
		present(alertController, animated: true)
	}

	@objc func exitButtonClicked() {
		let alert = UIAlertController(title: "exitTitle", message: "exitMessage", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "yes", style: .destructive, handler: { action in
			self.viewModel.exit()
		}))
		self.present(alert, animated: true)
	}
}

extension SettingsViewController: SettingsViewModelDelegate {
	
	func settingsViewModel(_ settingsViewModel: SettingsViewModel, readyToExit: Bool) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let startController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startVC") as! UINavigationController
		appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
		appDelegate.window?.rootViewController = startController
	}
	
}
