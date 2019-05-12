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
	var webSocketModel: WebSocketModel?
	var shown: Bool!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "Queue"
		self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Copy Link", style: .plain, target: self, action: #selector(self.copyLinkButtonClicked)), animated: false)
		
		setupViewModel()
		configureEventsTable()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.updateEvent(refresher: false)
		shown = true
		configureWebSocketModel()
		configureQueueInfo()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		webSocketModel?.disconnect()
		shown = false
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
		
		queueTableView.refreshControl = UIRefreshControl()
		queueTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
		queueTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
	}
	
	@objc func refresh(sender:AnyObject) {
		viewModel.updateEvent(refresher: true)
	}
	
	@IBOutlet weak var webSocketConnection: UIImageView!
	
	func configureWebSocketModel() {
		webSocketConnection.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
		webSocketConnection.layer.cornerRadius = webSocketConnection.layer.width/2
		webSocketModel = WebSocketModel(queueId: viewModel.queue.id)
		webSocketModel?.delegate = self
	}
	
	@IBAction func additionalInfoClicked(_ sender: Any) {
		let eventInfoViewController = EventInfoViewController()
		eventInfoViewController.viewModel = viewModel
		self.show(eventInfoViewController, sender: self)
	}
	
	@IBAction func takeSequent(_ sender: Any) {
		
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
		let filteredQueue = viewModel.queue.busyPlaces.filter { $0.place == (indexPath.section + 1) }
		cell.viewModel = self.viewModel
		if filteredQueue.count > 0 {
			cell.set(user: filteredQueue[0].user, to: indexPath.section + 1, interactable: true)
		} else {
			cell.set(user: nil, to: indexPath.section + 1, interactable: true)
		}
		cell.layer.borderColor = UIColor.clear.cgColor
		cell.layer.borderWidth = 1
		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true
		
		return cell
	}
	
}

extension EventViewController: EventViewModelDelegate {
	
	func eventViewModel(_ eventViewModel: EventViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func eventViewModel(_ eventViewModel: EventViewModel, isSuccess: Bool, didRecieveMessage message: String?) {
		if isSuccess {
			queueTableView.reloadData()
			configureQueueInfo()
		} else {
			print(message as Any)
		}
	}
	
	func eventViewModel(_ eventViewModel: EventViewModel, endRefreshing: Bool) {
		if endRefreshing {
			self.queueTableView.refreshControl?.endRefreshing()
			self.queueTableView.reloadData()
		}
	}

}

extension EventViewController: WebSocketModelDelegate {
	
	func webSocketModel(isListening: Bool) {
		if isListening {
			self.webSocketConnection.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
		} else {
			self.webSocketConnection.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
			self.webSocketModel = nil
			if shown {
				let alert = UIAlertController(title: "Disconnected", message: "Real-time connection lost", preferredStyle: UIAlertController.Style.alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive))
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	func regStarts() {
		
	}
	
	func regEnds() {
		
	}
	
	func take(place: PlaceCashe) {
		
	}
	
	func free(place: PlaceCashe) {
		
	}
	
	func changed(queue: QueueCashe) {
		
	}
	
	func mixed(queue: QueueCashe) {
		
	}
	
	func webSocketModel(didRecievedError: String) {
		
	}
	
	
	
	
}
