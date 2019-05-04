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
		title = "Settings"
		self.navigationController?.title = nil
		form
			+++
			Section("My Profile")
			
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
			
			+++
			Section("Application Settings")
			
				<<< PickerInlineRow<String>("Appearance ") { (row : PickerInlineRow<String>) -> Void in
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
					self?.showAlert()
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

}
