//
//  UserPageViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class QueueManagerViewController: UIViewController, UISearchBarDelegate {

	private let viewModel: UserPageViewModel = UserPageViewModel()
	
	@IBOutlet weak var eventsTable: UITableView!
	
	@IBOutlet weak var searchBar:UISearchBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Queue Manager"
		navigationController?.title = nil
		self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createButtonClicked)), animated: false)
		configureEventsTable()
		configureSearchBar()
	}
	
	func configureEventsTable() {
		eventsTable.delegate = self
		eventsTable.dataSource = self
		eventsTable.tableFooterView = UIView()
	}
	
	func configureSearchBar() {
		searchBar.delegate = self
		
		searchBar.searchBarStyle = UISearchBar.Style.minimal
		searchBar.backgroundImage = UIImage()
		searchBar.sizeToFit()
		searchBar.isTranslucent = false
		searchBar.placeholder = "Search by name or url"
	}
	
	@objc func createButtonClicked() {
		/*
		let storyBoard = UIStoryboard(name: "", bundle: nil)
		let viewController = storyBoard.instantiateViewController(withIdentifier: "")
		self.navigationController?.pushViewController(viewController, animated: true)
		*/
	}
	
}

extension QueueManagerViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.isSelected = false
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
		
		return cell
	}
	
}

extension QueueManagerViewController {
	
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.setShowsCancelButton(true, animated: true)
		navigationController?.setNavigationBarHidden(true, animated: true)
		return true
	}
	
	func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.setShowsCancelButton(false, animated: true)
		navigationController?.setNavigationBarHidden(false, animated: true)
		return true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
}
