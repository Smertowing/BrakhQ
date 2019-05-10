//
//  EventViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

	var viewModel: EventViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "Queue"
		self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Copy Link", style: .plain, target: self, action: #selector(self.copyLinkButtonClicked)), animated: false)
		
		setupViewModel()
		configureQueueInfo()
		configureEventsTable()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.updateEvent()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		timer?.invalidate()
	}
	
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var eventDateLabel: UILabel!
	@IBOutlet weak var untilLabel: UILabel!
	@IBOutlet weak var counterLabel: UILabel!
	@IBOutlet weak var sitesLabel: UILabel!
	@IBOutlet weak var randomLabel: UILabel!
	
	@IBOutlet weak var queueTableView: UITableView!
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	func configureQueueInfo() {
		eventNameLabel.text = viewModel.queue.name
		eventDateLabel.text = viewModel.queue.eventDate.displayDate + " " + viewModel.queue.eventDate.displayTime
		sitesLabel.text = "\(viewModel.queue.busyPlaces.count)/\(viewModel.queue.placesCount)"
		if viewModel.queue.queueType == .def {
			randomLabel.isHidden = true
		}
		if viewModel.queue.regActive {
			runCountdown()
			untilLabel.isHidden = false
			untilLabel.text = "Until end of registration:"
		} else if viewModel.queue.regEnded {
			counterLabel.text = "Registration is over"
			untilLabel.isHidden = true
		} else {
			runCountdown()
			untilLabel.isHidden = false
			untilLabel.text = "Until start of registration"
		}
	}
	
	var timer : Timer?

	var countdown: DateComponents {
		return Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: viewModel.queue.regActive ? viewModel.queue.regEndDate : viewModel.queue.regStartDate)
	}
	
	@objc func updateTime() {
		let countdown = self.countdown
		let days = countdown.day!
		let hours = countdown.hour!
		let minutes = countdown.minute!
		let seconds = countdown.second!
		if (days >= 0) && (hours >= 0) && (minutes >= 0) && (seconds >= 0) {
			counterLabel.text = String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
		} else {
			counterLabel.text = ("00:00:00:00")
		}
	}
	
	func runCountdown() {
		timer?.invalidate()
		updateTime()
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
	}
	
	func configureEventsTable() {
		queueTableView.delegate = self
		queueTableView.dataSource = self
		queueTableView.tableFooterView = UIView()
		queueTableView.allowsSelection = false
	}
	
	@IBAction func additionalInfoClicked(_ sender: Any) {
		let eventInfoViewController = EventInfoViewController()
		eventInfoViewController.viewModel = viewModel
		self.show(eventInfoViewController, sender: self)
	}
	
	@objc func copyLinkButtonClicked() {
		
	}
	
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.queue.placesCount
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 5
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor.clear
		return headerView
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "siteCell", for: indexPath) as! SiteTableViewCell
		let filteredQueue = viewModel.queue.busyPlaces.filter { $0.place == indexPath.section }
		cell.viewModel = self.viewModel
		if filteredQueue.count > 0{
			cell.set(user: filteredQueue[0].user, to: indexPath.section)
		} else {
			cell.set(user: nil, to: indexPath.section)
		}
		cell.layer.borderColor = UIColor.clear.cgColor
		cell.layer.borderWidth = 1
		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true
		
		return cell
	}
	
}

extension EventViewController: EventViewModelDelegate {
	
	func eventViewModelDelegate(_ eventViewModelDelegate: EventViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func eventViewModelDelegate(_ eventViewModelDelegate: EventViewModel, isSuccess: Bool, didRecieveMessage message: String?) {
		if isSuccess {
			queueTableView.reloadData()
			configureQueueInfo()
		} else {
			print(message as Any)
		}
	}

}
