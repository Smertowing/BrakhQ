//
//  EditEventViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

class EditEventViewController: FormViewController {

	private let viewModel: EditEventViewModel
	private let delegate: EventInfoViewControllerDelegate
	
	init(viewModel: EditEventViewModel, delegate: EventInfoViewControllerDelegate) {
		self.viewModel = viewModel
		self.delegate = delegate
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "Edit Queue"
		self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonClicked)), animated: false)
		setupViewModel()
		initializeForm()
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	private func initializeForm() {
		
		form
			+++
			Section("Event Info")
			<<< LabelRow("Title") {
				$0.title = $0.tag
				$0.value = viewModel.queue.name
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
			}
		
			<<< DateTimeInlineRow("Event Date"){
				$0.title = $0.tag
				$0.value = viewModel.queue.eventDate
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.onChange { [weak self] row in
					let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
					if (row.value?.compare(Date()) == .orderedAscending) || (row.value?.compare(startDate.value!) == .orderedAscending) {
						row.cell!.detailTextLabel?.textColor = .red
					} else {
						row.cell!.detailTextLabel?.textColor = row.cell!.tintColor
					}
					row.updateCell()
				}
				.onExpandInlineRow {cell, row, inlineRow in
					inlineRow.cellUpdate { cell, dateRow in
						cell.datePicker.datePickerMode = .dateAndTime
					}
					let color = UIColor.gray
					row.onCollapseInlineRow { cell, _, _ in
						if  cell.detailTextLabel?.textColor != .red {
							cell.detailTextLabel?.textColor = color
						}
					}
					if  cell.detailTextLabel?.textColor != .red {
						cell.detailTextLabel?.textColor = cell.tintColor
					}
			}
			
			+++
			Section("Desription (optional)")
			<<< TextAreaRow("Description") {
				$0.value = viewModel.queue.descript
				}
				.cellSetup { cell, row in
					cell.textView.text = ""
			}
			
			+++
			Section("Queue Settings")
			
			<<< StepperRow("Number of Sites") {
				$0.title = $0.tag
				$0.value = Double(viewModel.queue.placesCount)
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				$0.cell.stepper.stepValue = 1
				$0.cell.stepper.maximumValue = 1000
				$0.cell.stepper.minimumValue = 2
				$0.displayValueFor = { value in
					guard let value = value else { return nil }
					return "\(Int(value))"
				}
			}
			
			+++
			Section("Registration Dates")
			<<< DateTimeInlineRow("Starts") {
				$0.title = $0.tag
				$0.value = viewModel.queue.regStartDate
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.onChange { [weak self] row in
					let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends")
					if row.value?.compare(endRow.value!) == .orderedDescending {
						row.cell!.detailTextLabel?.textColor = .red
					} else {
						row.cell!.detailTextLabel?.textColor = row.cell!.tintColor
					}
					row.updateCell()
				}
				.onExpandInlineRow {cell, row, inlineRow in
					inlineRow.cellUpdate { cell, dateRow in
						cell.datePicker.datePickerMode = .dateAndTime
					}
					let color = UIColor.gray
					row.onCollapseInlineRow { cell, _, _ in
						if  cell.detailTextLabel?.textColor != .red {
							cell.detailTextLabel?.textColor = color
						}
					}
					if  cell.detailTextLabel?.textColor != .red {
						cell.detailTextLabel?.textColor = cell.tintColor
					}
			}
			
			<<< DateTimeInlineRow("Ends"){
				$0.title = $0.tag
				$0.value = viewModel.queue.regEndDate
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.onChange { [weak self] row in
					let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
					if row.value?.compare(startRow.value!) == .orderedAscending {
						row.cell!.detailTextLabel?.textColor = .red
					} else {
						row.cell!.detailTextLabel?.textColor = row.cell!.tintColor
					}
					row.updateCell()
				}
				.onExpandInlineRow {cell, row, inlineRow in
					inlineRow.cellUpdate { cell, dateRow in
						cell.datePicker.datePickerMode = .dateAndTime
					}
					let color = UIColor.gray
					row.onCollapseInlineRow { cell, _, _ in
						if  cell.detailTextLabel?.textColor != .red {
							cell.detailTextLabel?.textColor = color
						}
					}
					if  cell.detailTextLabel?.textColor != .red {
						cell.detailTextLabel?.textColor = cell.tintColor
					}
			}
			
			+++
			Section()
			<<< ButtonRow("Save") { (row: ButtonRow) -> Void in
				row.title = "Save Changes"
				}
				.onCellSelection { (cell, row) in
					self.saveButtonClicked()
		}
		
	}
	
	@objc func saveButtonClicked() {
		if form.validate().isEmpty {
			let description: TextAreaRow! = form.rowBy(tag: "Description")
			let eventDate: DateTimeInlineRow! = form.rowBy(tag: "Event Date")
			let regStart: DateTimeInlineRow! = form.rowBy(tag: "Starts")
			let regEnd: DateTimeInlineRow! = form.rowBy(tag: "Ends")
			let placesCount: StepperRow! = form.rowBy(tag: "Number of Sites")
			viewModel.editEvent(description: description.value,
													regStart: regStart.value,
													eventDate: eventDate.value,
													regEnd: regEnd.value,
													placesCount: Int(placesCount.value!))
		}
	}

}

extension EditEventViewController: EditEventViewModelDelegate {
	
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, isSuccess: Bool, didRecieveMessage message: String?) {
		if isSuccess {
			let alert = UIAlertController(title: "Successfull", message: "You've created event queue!", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
				_ = self.navigationController?.popViewController(animated: true)
				self.delegate.eventUpdated()
			})
			self.present(alert, animated: true, completion: nil)
		} else {
			let alert = UIAlertController(title: "Failure", message: message ?? "There was an error, try again", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
}
