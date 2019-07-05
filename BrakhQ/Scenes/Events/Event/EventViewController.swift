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
		title = nil
		self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Copy Link".localized, style: .plain, target: self, action: #selector(self.copyLinkButtonClicked)), animated: false)
		
		setupViewModel()
		configureEventsTable()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.updateEvent(refresher: false)
		webSocketConnection.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
		webSocketConnection.layer.cornerRadius = webSocketConnection.layer.width/2
		configureQueueInfo()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		shown = true
		configureWebSocketModel()
		super.viewDidAppear(animated)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		webSocketModel?.disconnect()
		shown = false
		timer?.invalidate()
	}
	
	@IBOutlet weak var eventNameView: UIView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var eventDateLabel: UILabel!
	@IBOutlet weak var untilLabel: UILabel!
	@IBOutlet weak var counterLabel: UILabel!
	@IBOutlet weak var sitesLabel: UILabel!
	@IBOutlet weak var randomLabel: UILabel!
	
	@IBOutlet weak var takeSequentButton: UIButton!
	@IBOutlet weak var queueTableView: UITableView!
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	func configureQueueInfo() {
		eventNameView.layer.cornerRadius = 10
		eventNameLabel.text = viewModel.queue.name
		eventDateLabel.text = viewModel.queue.eventDate.displayDate + " " + viewModel.queue.eventDate.displayTime
		sitesLabel.text = "\(viewModel.queue.busyPlaces.count)/\(viewModel.queue.placesCount)"
		if viewModel.queue.queueType == .def {
			randomLabel.isHidden = true
		}
		if viewModel.queue.regActive {
			runCountdown()
			untilLabel.isEnabled = false
			untilLabel.text = "Until end of registration:".localized
			takeSequentButton.isEnabled = true
		} else if viewModel.queue.regEnded {
			counterLabel.text = "Registration is over".localized
			untilLabel.isEnabled = true
			takeSequentButton.isEnabled = false
		} else {
			runCountdown()
			untilLabel.isEnabled = false
			untilLabel.text = "Until start of registration:".localized
			takeSequentButton.isEnabled = false
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
		queueTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...".localized)
		queueTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
	}
	
	@objc func refresh(sender:AnyObject) {
		viewModel.updateEvent(refresher: true)
		configureWebSocketModel()
		configureQueueInfo()
	}
	
	@IBOutlet weak var webSocketConnection: UIImageView!
	
	func configureWebSocketModel() {
		webSocketModel = WebSocketModel(queueId: viewModel.queue.id)
		webSocketModel?.delegate = self
	}
	
	@IBAction func additionalInfoClicked(_ sender: Any) {
		if viewModel.queue.owner.id == AuthManager.shared.user?.id {
			let viewModel = EditEventViewModel(for: self.viewModel.queue)
			let editEventViewController = EditEventViewController(viewModel: viewModel, delegate: self)
			self.show(editEventViewController, sender: self)
		} else {
			let eventInfoViewController = EventInfoViewController()
			eventInfoViewController.viewModel = viewModel
			self.show(eventInfoViewController, sender: self)
		}
	}
	
	@IBAction func takeSequent(_ sender: Any) {
		viewModel.takeSequent()
	}
	
	@objc func copyLinkButtonClicked() {
		UIPasteboard.general.string = "https://queue.brakh.men/queue/\(viewModel.queue.url)"
		let alert = UIAlertController(title: "Done".localized, message: "Link to this queue successfully copied to your clipboard!".localized, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default))
		self.present(alert, animated: true, completion: nil)
	}
	
	func prepareForReloadTable() {
		viewModel.setPlaceConfigs()
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

		cell.viewModel = self.viewModel
		cell.set(config: viewModel.places[indexPath.section])

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
	
	func eventViewModel(_ eventViewModel: EventViewModel, isSuccess: Bool, didRecieveMessage error: NetworkError!) {
		if isSuccess {
			prepareForReloadTable()
			configureQueueInfo()
		} else {
			print(error?.localizedDescription as Any)
		}
	}
	
	func eventViewModel(_ eventViewModel: EventViewModel, endRefreshing: Bool) {
		if endRefreshing {
			self.queueTableView.refreshControl?.endRefreshing()
			self.prepareForReloadTable()
		}
	}
	
	func eventViewModel(_ eventViewModel: EventViewModel, endConfigurating: Bool) {
		queueTableView.reloadData()
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
				let alert = UIAlertController(title: "Disconnected".localized, message: "Real-time connection lost".localized, preferredStyle: UIAlertController.Style.alert)
				alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.destructive))
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	func regStarts() {
		viewModel.updateEvent(refresher: false)
	}
	
	func regEnds() {
		viewModel.updateEvent(refresher: false)
	}
	
	func take(place: Place) {
		viewModel.queue.add(place)
		viewModel.setPlaceConfigs()
		viewModel.updateEvent(refresher: false)
	}
	
	func free(place: Place) {
		viewModel.queue.remove(place)
		viewModel.setPlaceConfigs()
		viewModel.updateEvent(refresher: false)
	}
	
	func changed(queue: Queue) {
		viewModel.queue = QueueCashe(queue: queue)
		viewModel.setPlaceConfigs()
	}
	
	func mixed(queue: Queue) {
		viewModel.queue = QueueCashe(queue: queue)
		viewModel.setPlaceConfigs()
	}
	
	func webSocketModel(didRecievedError: String) {
		let alert = UIAlertController(title: "Failure".localized, message: didRecievedError, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.destructive))
		self.present(alert, animated: true, completion: nil)
	}
	
}

extension EventViewController: EditEventViewControllerDelegate {
	
	func deleted() {
		shown = false
		_ = self.navigationController?.popViewController(animated: true)
	}
	
	func eventUpdated() {
		//_ = self.navigationController?.popViewController(animated: true)
	}
	
}
