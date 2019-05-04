//
//  UserPageViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class UserPageViewController: UIViewController {

	private let viewModel: UserPageViewModel = UserPageViewModel()
	
	@IBOutlet weak var eventsTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Queue Manager"
		self.navigationController?.title = nil
		eventsTable.delegate = self
		eventsTable.dataSource = self
	}

}

extension UserPageViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
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

