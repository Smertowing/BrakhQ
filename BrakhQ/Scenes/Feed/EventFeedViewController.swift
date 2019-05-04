//
//  EventFeedViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class EventFeedViewController: UIViewController {

	private let viewModel: EventFeedViewModel = EventFeedViewModel()

	@IBOutlet weak var eventsTable: UITableView!  
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Feed"
		self.navigationController?.title = nil
		eventsTable.delegate = self
		eventsTable.dataSource = self
	}
    
}

extension EventFeedViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 130
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.isSelected = false
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
		
		return cell
	}
	
}
