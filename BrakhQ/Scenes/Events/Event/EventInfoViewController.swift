//
//  EventInfoViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

class EventInfoViewController: FormViewController {

	weak var viewModel: EventViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		configureForm()
	}
	
	func configureForm() {
		form
			+++
			Section("Event Info".localized)
			<<< LabelRow("Title") {
				$0.title = $0.tag?.localized
				$0.value = viewModel?.queue.name
			}
			
			<<< LabelRow("Event Date") {
				$0.title = $0.tag?.localized
				$0.value = viewModel.queue.eventDate.displayDate + " " + viewModel.queue.eventDate.displayTime
			}
			
			+++
			Section("Description".localized)
			<<< TextAreaRow() {
				$0.value = viewModel.queue.descript
				$0.disabled = true
				$0.resetValue = viewModel.queue.descript
				}
				.onChange { row in
					row.resetRowValue()
				}
				.cellSetup { cell, row in
					cell.textView.text = "Description".localized
			}
			
			+++
			Section("Queue".localized)
			<<< LabelRow("Owner") {
				$0.title = $0.tag?.localized
				$0.value = viewModel.queue.owner.name
			}
			
			<<< LabelRow("Sites") {
				$0.title = $0.tag?.localized
				$0.value = "\(viewModel.queue.busyPlaces.count)/\(viewModel.queue.placesCount)"
			}
			
			<<< ButtonRow("URL") { (row: ButtonRow) -> Void in
				row.title = "Copy Link".localized
				}
				.onCellSelection { (cell, row) in
					UIPasteboard.general.string = "https://queue.brakh.men/queue/\(self.viewModel.queue.url)"
					let alert = UIAlertController(title: "Done".localized, message: "Link to this queue successfully copied to your clipboard!".localized, preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default))
					self.present(alert, animated: true, completion: nil)
			}
			
			+++
			Section("Queue Settings".localized)
			<<< LabelRow("Type") {
				$0.title = $0.tag?.localized
				$0.value = viewModel.queue.queueType.rawValue
			}
			
			<<< LabelRow("Number of Sites") {
				$0.title = $0.tag?.localized
				$0.value = "\(viewModel.queue.placesCount)"
			}
			
			+++
			Section("Registration Dates".localized)
			<<< LabelRow("Starts") {
				$0.title = $0.tag?.localized
				$0.value = viewModel.queue.regStartDate.displayDate + " " + viewModel.queue.eventDate.displayTime
			}
			
			<<< LabelRow("Ends"){
				$0.title = $0.tag?.localized
				$0.value = viewModel.queue.regEndDate.displayDate + " " + viewModel.queue.eventDate.displayTime
			}
		
	}
	
}
