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
		title = "My Queues"
		navigationController?.title = nil
		navigationController?.navigationBar.isTranslucent = false
		tabBarController?.tabBar.isTranslucent = false
		self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createButtonClicked)), animated: false)
		self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchButtonClicked)), animated: false)
		setupViewModel()
		configureEventsTable()
	//	configureSearchBar()
		configureScopeBar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.view.isUserInteractionEnabled = true
		viewModel.refresh(refresher: false)
	}
	
	private func setupViewModel() {
		viewModel.delegate = self
	}
	
	func configureEventsTable() {
		eventsTable.delegate = self
		eventsTable.dataSource = self
		eventsTable.tableFooterView = UIView()
		
		eventsTable.refreshControl = UIRefreshControl()
		eventsTable.refreshControl?.attributedTitle = NSAttributedString(string: "Loading...")
		eventsTable.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
	}
	
	@objc func refresh(sender:AnyObject) {
		viewModel.refresh(refresher: true)
	}
	
	@IBOutlet weak var scopeSegmentedControl: UISegmentedControl!
	
	func configureScopeBar() {
		scopeSegmentedControl.setTitle("All", forSegmentAt: 0)
		scopeSegmentedControl.setTitle("Managed", forSegmentAt: 1)
	}
	
	@IBAction func segmentChanged(_ sender: Any) {
		viewModel.filterQueues(restrictToManaged: scopeSegmentedControl.selectedSegmentIndex == 1)
	}
	
	func configureSearchBar() {
		searchBar.delegate = self
		
		searchBar.searchBarStyle = UISearchBar.Style.minimal
		searchBar.backgroundImage = UIImage()
		searchBar.sizeToFit()
		searchBar.isTranslucent = false
		searchBar.placeholder = "Filter my queues by..."
		
		searchBar.scopeBarBackgroundImage = UIImage()
		searchBar.showsScopeBar = true
		searchBar.scopeButtonTitles = ["All", "Managed"]
	}
	
	@objc func createButtonClicked() {
		let viewModel = CreateEventViewModel()
		self.show(CreateEventViewController(viewModel: viewModel), sender: self)
	}
	
	@objc func searchButtonClicked() {
		alertWithTextField(title: "Search queue", message: "Enter link to the queue to enter it", placeholder: "queue.brakh.men/...") { result in
			if !result.isEmpty {
				self.viewModel.searchBy(result)
			}
		}
	}
	
	public func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addTextField() { newTextField in
			newTextField.placeholder = placeholder
		}
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("") })
		alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
			if
				let textFields = alert.textFields,
				let tf = textFields.first,
				let result = tf.text
			{ completion(result) }
			else
			{ completion("") }
		})
		navigationController?.present(alert, animated: true)
	}
	
}

extension QueueManagerViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.queues.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.view.isUserInteractionEnabled = false
		let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
		cell.isSelected = false
		
		let storyBoard = UIStoryboard(name: "Event", bundle: nil)
		let viewController = storyBoard.instantiateViewController(withIdentifier: "eventViewController") as! EventViewController
		viewController.viewModel = EventViewModel(for: cell.currentQueue)
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
		cell.setQueue(viewModel.queues[indexPath.row])
		
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
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, reload: Bool) {
		if reload {
			eventsTable.reloadData()
		}
	}
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, found: Bool, queue: QueueCashe?, didRecieveMessage message: String?) {
		if found {
			let storyBoard = UIStoryboard(name: "Event", bundle: nil)
			let viewController = storyBoard.instantiateViewController(withIdentifier: "eventViewController") as! EventViewController
			viewController.viewModel = EventViewModel(for: queue!)
			self.navigationController?.pushViewController(viewController, animated: true)
		} else {
			let alert = UIAlertController(title: "Failure", message: message ?? "There was an error, try again", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isLoading: Bool) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
	}
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, endRefreshing: Bool) {
		if endRefreshing {
			eventsTable.refreshControl?.endRefreshing()
		}
	}
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isSuccess: Bool, didRecieveMessage message: String?) {
		if isSuccess {
			viewModel.filterQueues(restrictToManaged: scopeSegmentedControl.selectedSegmentIndex == 1)
		} else {
			print(message as Any)
		}
	}
	
}
