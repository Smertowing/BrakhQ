//
//  EventInfoViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

protocol EventInfoViewControllerDelegate {

	func eventUpdated()
	
}

class EventInfoViewController: FormViewController {

	weak var viewModel: EventViewModel!
	
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
				$0.title = $0.tag
				$0.value = viewModel?.queue.name
			}
			
			<<< LabelRow("Event Date") {
				$0.title = $0.tag
				$0.value = viewModel.queue.eventDate.displayDate + " " + viewModel.queue.eventDate.displayTime
			}
			
			+++
			Section("Description")
			<<< TextAreaRow() {
				$0.value = viewModel.queue.descript
				$0.resetValue = viewModel.queue.descript
				}
				.onChange { row in
					row.resetRowValue()
				}
				.cellSetup { cell, row in
					cell.textView.text = "Description?"
			}
			
			+++
			Section("Queue")
			<<< LabelRow("Owner") {
				$0.title = $0.tag
				$0.value = viewModel.queue.owner.name
			}
			
			<<< LabelRow("Sites") {
				$0.title = $0.tag
				$0.value = "\(viewModel.queue.busyPlaces.count)/\(viewModel.queue.placesCount)"
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
				$0.value = viewModel.queue.queueType.rawValue
			}
			
			<<< LabelRow("Number of Sites") {
				$0.title = $0.tag
				$0.value = "\(viewModel.queue.placesCount)"
			}
			
			+++
			Section("Registration Dates")
			<<< LabelRow("Starts") {
				$0.title = $0.tag
				$0.value = viewModel.queue.regStartDate.displayDate + " " + viewModel.queue.eventDate.displayTime
			}
			
			<<< LabelRow("Ends"){
				$0.title = $0.tag
				$0.value = viewModel.queue.regEndDate.displayDate + " " + viewModel.queue.eventDate.displayTime
			}
		
	}
	
	@objc func editButtonClicked() {
		let viewModel = EditEventViewModel(for: self.viewModel.queue)
		let editEventViewController = EditEventViewController(viewModel: viewModel, delegate: self)
		self.show(editEventViewController, sender: self)
	}
	
}

extension EventInfoViewController: EventInfoViewControllerDelegate {
	
	func eventUpdated() {
		_ = self.navigationController?.popViewController(animated: true)
	}
	
}
