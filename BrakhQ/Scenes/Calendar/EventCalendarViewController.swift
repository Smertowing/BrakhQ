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

	private let viewModel: QueueManagerViewModel
	
	init(viewModel: QueueManagerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "Calendar"
		self.navigationController?.title = nil
		navigationController?.navigationBar.isTranslucent = false
		tabBarController?.tabBar.isTranslucent = false
		dayView.autoScrollToFirstEvent = false
		reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.refresh(refresher: false)
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	override func eventsForDate(_ date: Date) -> [EventDescriptor] {
		var events = [Event]()
		for queue in DataManager.shared.feed.queues {
			if queue.eventDate.compareTo(date: date, toGranularity: .day) == .orderedSame {
				let event = Event()
				event.startDate = queue.eventDate
				event.endDate = queue.eventDate.addingTimeInterval(60*60)
				event.text = queue.name + " - Event date"
				events.append(event)
			}
			if queue.regStartDate.compareTo(date: date, toGranularity: .day) == .orderedSame {
				let event = Event()
				event.startDate = queue.regStartDate
				event.endDate = queue.regStartDate.addingTimeInterval(60*60)
				event.text = queue.name + " - Registration starts"
				events.append(event)
			}
			if queue.regEndDate.compareTo(date: date, toGranularity: .day) == .orderedSame {
				let event = Event()
				event.startDate = queue.regEndDate
				event.endDate = queue.regEndDate.addingTimeInterval(60*60)
				event.text = queue.name + " - Registration ends"
				events.append(event)
			}
		}
		return events
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

extension EventCalendarViewController: QueueManagerViewModelDelegate {
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, endRefreshing: Bool) {
		
	}
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isSuccess: Bool, didRecieveMessage message: String?) {
		if isSuccess {
			reloadData()
		} else {
			print(message as Any)
		}
	}
	
}
