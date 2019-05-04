//
//  EventCalendarViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import CalendarKit
import DateToolsSwift

class EventCalendarViewController: DayViewController {

	private let viewModel: EventCalendarViewModel
	
	init(viewModel: EventCalendarViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Calendar"
		self.navigationController?.title = nil
		navigationController?.navigationBar.isTranslucent = false
		dayView.autoScrollToFirstEvent = false
		reloadData()
	}
	
	override func eventsForDate(_ date: Date) -> [EventDescriptor] {
		return viewModel.events(for: date)
	}
	
	//Delegate

	override func dayViewDidSelectEventView(_ eventView: EventView) {
		guard let descriptor = eventView.descriptor as? Event else {
			return
		}
		print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
	}
	
	override func dayViewDidLongPressEventView(_ eventView: EventView) {
		guard let descriptor = eventView.descriptor as? Event else {
			return
		}
		print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
	}
	
	override func dayView(dayView: DayView, willMoveTo date: Date) {
		print("DayView = \(dayView) will move to: \(date)")
	}
	
	override func dayView(dayView: DayView, didMoveTo date: Date) {
		print("DayView = \(dayView) did move to: \(date)")
	}
	
}

