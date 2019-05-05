//
//  EventInfoViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

protocol EventInfoViewControllerDelegate: class {
	func EventInfoViewControllerDidUpdated(_ controller: EventInfoViewController)
}

class EventInfoViewController: FormViewController {

	weak var viewModel: EventViewModel?
	weak var delegate: EventInfoViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonClicked)), animated: false)
		
		configureForm()
	}
	
	func configureForm() {
		form
			+++
			Section("Event Info")
			<<< LabelRow("Title") {
				$0.title = "Event Title"
			}
			
			<<< LabelRow("Event Date") {
				$0.title = "\(Date().addingTimeInterval(60*60*25))"
			}
			
			+++
			Section("Description")
			<<< TextAreaRow()
				.cellSetup { cell, row in
					cell.textView.text = "Description?"
			}
			
			+++
			Section("Queue")
			<<< LabelRow("Owner") {
				$0.title = $0.tag
				$0.value = "Kiryl Holubeu"
			}
			
			<<< LabelRow("Sites") {
				$0.title = $0.tag
				$0.value = "\(0)/\(0)"
			}
			
			<<< ButtonRow("URL") { (row: ButtonRow) -> Void in
				row.title = "Copy URL"
				}
				.onCellSelection { [weak self] (cell, row) in
			}
			
			+++
			Section("Queue Settings")
			<<< LabelRow("Type") {
				$0.title = $0.tag
				$0.value = "Default"
			}
			
			<<< LabelRow("Number of Sites") {
				$0.title = $0.tag
				$0.value = "\(7)"
			}
			
			+++
			Section("Registration Dates")
			<<< LabelRow("Starts") {
				$0.title = $0.tag
				$0.value = "\(Date().addingTimeInterval(60*60))"
			}
			
			<<< LabelRow("Ends"){
				$0.title = $0.tag
				$0.value = "\(Date().addingTimeInterval(60*60*24))"
			}
		
	}
	
	@objc func editButtonClicked() {
		let viewModel = EditEventViewModel()
		self.show(EditEventViewController(viewModel: viewModel), sender: self)
	}
	
}
