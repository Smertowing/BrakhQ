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
		title = "New Queue"
		self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(self.createButtonClicked)), animated: false)
		initializeForm()
	}
	
	private func initializeForm() {
		
		form
			+++
			Section("Event Info")
			<<< TextRow("Title").cellSetup { cell, row in
				cell.textField.placeholder = row.tag
			}
			<<< TextRow("Description (optional)").cellSetup { cell, row in
				cell.textField.placeholder = row.tag
			}
			<<< DateTimeInlineRow("Event Date"){
				$0.title = $0.tag
				$0.value = Date().addingTimeInterval(60*60*24)
				}
				.onChange { [weak self] row in
					let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts:")
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
			Section("Queue Settings")
			<<< SegmentedRow<String>(){
				$0.title = "Allocation"
				$0.options = ["Default", "Random"]
				$0.value = "Default"
				}.onChange { row in
					
			}
			
			<<< StepperRow() {
				$0.title = "Number of sites"
				$0.value = 2
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
			<<< DateTimeInlineRow("Starts:") {
				$0.title = $0.tag
				$0.value = Date().addingTimeInterval(60*60)
				}
				.onChange { [weak self] row in
					let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends:")
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
			
			<<< DateTimeInlineRow("Ends:"){
				$0.title = $0.tag
				$0.value = Date().addingTimeInterval(60*60*24)
				}
				.onChange { [weak self] row in
					let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts:")
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
				row.title = "Create Queue"
				}
				.onCellSelection { [weak self] (cell, row) in
			}
		
	}
	
	@objc func createButtonClicked() {
		
	}
}
