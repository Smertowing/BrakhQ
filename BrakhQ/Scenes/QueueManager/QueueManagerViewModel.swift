//
//  QueueManagerViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

protocol QueueManagerViewModelDelegate: class {
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isLoading: Bool)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isSuccess: Bool, didRecieveMessage error: NetworkError!)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, endRefreshing: Bool)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, found: Bool, queue: QueueCashe?, didRecieveMessage error: NetworkError!)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, reload: Bool)
}

final class QueueManagerViewModel {
	
	weak var delegate: QueueManagerViewModelDelegate?
	
	var createdQueues: [QueueCashe] = DataManager.shared.createdFeed.queues.sorted(by: { (prev, next) -> Bool in
		return prev.id > next.id
	})
	var usedQueues: [QueueCashe] = DataManager.shared.usedFeed.queues.sorted(by: { (prev, next) -> Bool in
		return prev.id > next.id
	})
	
	func filterQueues(type: FeedKeys) {
		switch type {
		case .usedFeed:
			usedQueues = DataManager.shared.usedFeed.queues.sorted(by: { (prev, next) -> Bool in
				return prev.id > next.id
			})
		case .createdFeed:
			createdQueues = DataManager.shared.createdFeed.queues.sorted(by: { (prev, next) -> Bool in
				return prev.id > next.id
			})
		}
		delegate?.queueManagerViewModel(self, reload: true)
	}
	
	func searchBy(_ link: String) {
		let params = link.split(separator: "/")
		if let last = params.last {
			getQueue(by: String(last))
		} else {
			self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: .invalidRequest)
		}
	}
	
	func refresh(refresher: Bool) {
		updateEvents(with: refresher)
	}
	
	private func updateEvents(with refresher: Bool) {
		delegate?.queueManagerViewModel(self, isLoading: true)
		
		NetworkingManager.shared.getQeuesBy(userId: AuthManager.shared.user?.id ?? -1) { (result) in
			self.delegate?.queueManagerViewModel(self, isLoading: false)
			switch result {
			case .success(let queues):
				DataManager.shared.usedFeed = FeedCashe(queues: [])
				for queue in queues.used {
					DataManager.shared.addNew(queue, to: FeedKeys.usedFeed) {
						self.delegate?.queueManagerViewModel(self, isSuccess: true, didRecieveMessage: nil)
					}
				}
				DataManager.shared.createdFeed = FeedCashe(queues: [])
				for queue in queues.created {
					DataManager.shared.addNew(queue, to: FeedKeys.createdFeed) {
						self.delegate?.queueManagerViewModel(self, isSuccess: true, didRecieveMessage: nil)
					}
				}
			case .failure(let error):
				switch error {
				case .invalidCredentials:
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateEvents(with: refresher)
						} else {
							self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: .invalidCredentials)
							if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
						}
					}
				default:
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: error)
					if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
				}
			}
		}
	}
	
	func getQueue(by url: String) {
		delegate?.queueManagerViewModel(self, isLoading: true)
		
		NetworkingManager.shared.getQueue(url: url) { (result) in
			self.delegate?.queueManagerViewModel(self, isLoading: true)
			switch result {
			case .success(let queue):
				DataManager.shared.addNew(queue, to: FeedKeys.usedFeed) {
					self.delegate?.queueManagerViewModel(self, found: true, queue: QueueCashe(queue: queue), didRecieveMessage: nil)
				}
			case .failure(let error):
				switch error {
				case .invalidCredentials:
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.getQueue(by: url)
						} else {
							self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: .invalidCredentials)
						}
					}
				default:
					self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: error)
	
				}
			}
		}
	}
	
}
