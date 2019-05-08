//
//  QueueManagerViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class QueueManagerViewController: UIViewController {

	private let viewModel: QueueManagerViewModel = QueueManagerViewModel()
	
	@IBOutlet weak var eventsTable: UITableView!
	@IBOutlet weak var searchBar:UISearchBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		title = "Queue Manager"
		navigationController?.title = nil
		navigationController?.navigationBar.isTranslucent = false
		tabBarController?.tabBar.isTranslucent = false
		self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createButtonClicked)), animated: false)
		setupViewModel()
		configureEventsTable()
		configureSearchBar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.updateUsedEvents()
		viewModel.updateCreatedEvents()
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
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
		
		searchBar.scopeBarBackgroundImage = UIImage()
		searchBar.showsScopeBar = true
		searchBar.scopeButtonTitles = ["All", "Managed"]
	}
	
	@objc func createButtonClicked() {
		let viewModel = CreateEventViewModel()
		self.show(CreateEventViewController(viewModel: viewModel), sender: self)
	}
	
}

extension QueueManagerViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DataManager.shared.feed.queues.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
		cell.isSelected = false
		
		let storyBoard = UIStoryboard(name: "Event", bundle: nil)
		let viewController = storyBoard.instantiateViewController(withIdentifier: "eventViewController") as! EventViewController
		viewController.viewModel = EventViewModel(for: cell.currentQueue)
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
		cell.setQueue(DataManager.shared.feed.queues[indexPath.row])
		
		return cell
	}
	
}

extension QueueManagerViewController: UISearchBarDelegate, UISearchDisplayDelegate {
	
	
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
	
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		
	}
	
}

extension QueueManagerViewController: QueueManagerViewModelDelegate {
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isSuccess: Bool, didRecieveMessage message: String?) {
		if isSuccess {
			eventsTable.reloadData()
		} else {
			print(message as Any)
		}
	}
	
}
