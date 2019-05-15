//
//  CreateEventViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Eureka

class CreateEventViewController: FormViewController {

	private let viewModel: CreateEventViewModel
	
	init(viewModel: CreateEventViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "New Queue".localized
		self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Create".localized, style: .plain, target: self, action: #selector(self.createButtonClicked)), animated: false)
		
		setupViewModel()
		initializeForm()
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	private func initializeForm() {
		
		form
			+++
			Section("Event Info".localized)
			<<< TextRow("Title") {
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.cellSetup { cell, row in
				cell.textField.placeholder = row.tag?.localized
			}
			<<< DateTimeInlineRow("Event Date"){
				$0.title = $0.tag?.localized
				$0.value = Date().addingTimeInterval(60*60*24)
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
			Section("Description (optional)".localized)
			<<< TextAreaRow("Description")
				.cellSetup { cell, row in
					cell.textView.text = ""
			}
			
			+++
			Section("Queue Settings".localized)
			/*
			<<< SegmentedRow<String>("Allocation"){
				$0.title = $0.tag?.localized
				$0.options = [QueueType.def.rawValue, QueueType.random.rawValue]
				$0.value = QueueType.def.rawValue
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChangeAfterBlurred
				}
				.onChange { row in
					
			}
			*/
			<<< SwitchRow("Random") { row in
			row.title = row.tag
			}.onChange { row in
				row.updateCell()
			}
			
			<<< StepperRow("Number of Sites") {
				$0.title = $0.tag?.localized
				$0.value = 2
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
			Section("Registration Dates".localized)
			<<< DateTimeInlineRow("Starts") {
				$0.title = $0.tag?.localized
				$0.value = Date().addingTimeInterval(60*60)
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
				$0.title = $0.tag?.localized
				$0.value = Date().addingTimeInterval(60*60*24)
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
			<<< ButtonRow("Create") { (row: ButtonRow) -> Void in
				row.title = "Create Queue".localized
				}
				.onCellSelection { (cell, row) in
					self.createButtonClicked()
			}
		
	}
	
	@objc func createButtonClicked() {
		if form.validate().isEmpty {
			let title: TextRow! = form.rowBy(tag: "Title")
			let description: TextAreaRow! = form.rowBy(tag: "Description")
			let eventDate: DateTimeInlineRow! = form.rowBy(tag: "Event Date")
			//let queueType: SegmentedRow<String>! = form.rowBy(tag: "Allocation")
			let queueType: SwitchRow! = form.rowBy(tag: "Random")
			let regStart: DateTimeInlineRow! = form.rowBy(tag: "Starts")
			let regEnd: DateTimeInlineRow! = form.rowBy(tag: "Ends")
			let placesCount: StepperRow! = form.rowBy(tag: "Number of Sites")
			viewModel.createEvent(name: title.value!,
														description: description.value,
														//queueType: QueueType(rawValue: queueType.value!)!,
														queueType: queueType.value! ? QueueType.random : QueueType.def,
														regStart: regStart.value!,
														eventDate: eventDate.value!,
														regEnd: regEnd.value!,
														placesCount: Int(placesCount.value!))
		}
	}
}

extension CreateEventViewController: CreateEventViewModelDelegate {
	
	func createEventViewModel(_ createEventViewModel: CreateEventViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func createEventViewModel(_ createEventViewModel: CreateEventViewModel, isSuccess: Bool, didRecieveMessage message: String?) {
		if isSuccess {
			let alert = UIAlertController(title: "Successfull".localized, message: "You've created event queue".localized, preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) { _ in
				_ = self.navigationController?.popViewController(animated: true)
			})
			self.present(alert, animated: true, completion: nil)
		} else {
			let alert = UIAlertController(title: "Failure".localized, message: message ?? "There was an error".localized, preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default))
			self.present(alert, animated: true, completion: nil)
		}
	}

}
