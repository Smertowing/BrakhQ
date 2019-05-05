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
		
		configureEventsTable()
	}
	
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var eventDateLabel: UILabel!
	@IBOutlet weak var untilLabel: UILabel!
	@IBOutlet weak var counterLabel: UILabel!
	@IBOutlet weak var sitesLabel: UILabel!
	@IBOutlet weak var randomLabel: UILabel!
	
	@IBOutlet weak var queueTableView: UITableView!
	
	func configureEventsTable() {
		queueTableView.delegate = self
		queueTableView.dataSource = self
		queueTableView.tableFooterView = UIView()
		queueTableView.allowsSelection = false
	}
	
	@IBAction func additionalInfoClicked(_ sender: Any) {
		let eventInfoViewController = EventInfoViewController()
		eventInfoViewController.viewModel = viewModel
		eventInfoViewController.delegate = self
		self.show(eventInfoViewController, sender: self)
	}
	
	@objc func copyLinkButtonClicked() {
		
	}
	
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 7
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
		
		cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
		cell.layer.borderColor = UIColor.clear.cgColor
		cell.layer.borderWidth = 1
		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true
		
		return cell
	}
	
}

extension EventViewController: EventInfoViewControllerDelegate {
	
	func EventInfoViewControllerDidUpdated(_ controller: EventInfoViewController) {
		
	}
	
}
