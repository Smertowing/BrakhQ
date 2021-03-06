//
//  QueueManagerViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

protocol QueueManagerViewModelDelegate: class {
	
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isLoading: Bool)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, isSuccess: Bool, didRecieveMessage message: String?)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, endRefreshing: Bool)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, found: Bool, queue: QueueCashe?, didRecieveMessage message: String?)
	func queueManagerViewModel(_ queueManagerViewModel: QueueManagerViewModel, reload: Bool)
}

final class QueueManagerViewModel {
	
	weak var delegate: QueueManagerViewModelDelegate?
	let providerUser = MoyaProvider<UserAPIProvider>()
	let providerQueue = MoyaProvider<QueueAPIProvider>()
	
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
			self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Wrong input".localized)
		}
	}
	
	func refresh(refresher: Bool) {
		updateUsedEvents(with: refresher)
	}
	
	private func updateUsedEvents(with refresher: Bool) {
		delegate?.queueManagerViewModel(self, isLoading: true)
		providerUser.request(.getQueuesUsedBy(userId: AuthManager.shared.user?.id ?? -1)) { result in
			self.delegate?.queueManagerViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ModelResponseCollectionQueue.self) {
					if answer.success, let queues = answer.response {
						DataManager.shared.usedFeed = FeedCashe(queues: [])
						for queue in queues {
							DataManager.shared.addNew(queue, to: FeedKeys.usedFeed) {
								self.delegate?.queueManagerViewModel(self, isSuccess: true, didRecieveMessage: answer.message)
							}
						}
						self.updateCreatedEvents(with: refresher)
					} else {
						self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
						if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response".localized)
					if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
				}
			case .failure(let error):
				if error.errorDescription?.contains("401") ?? false || error.errorDescription?.contains("403") ?? false {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateUsedEvents(with: refresher)
						} else {
							self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application".localized)
							if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error".localized)
					if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
				}
			}
			
		}
	}

	private func updateCreatedEvents(with refresher: Bool) {
		delegate?.queueManagerViewModel(self, isLoading: true)
		providerUser.request(.getQueuesCreatedBy(userId: AuthManager.shared.user?.id ?? -1)) { result in
			self.delegate?.queueManagerViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ModelResponseCollectionQueue.self) {
					if answer.success, let queues = answer.response {
						DataManager.shared.createdFeed = FeedCashe(queues: [])
						for queue in queues {
							DataManager.shared.addNew(queue, to: FeedKeys.createdFeed) {
								self.delegate?.queueManagerViewModel(self, isSuccess: true, didRecieveMessage: answer.message)
							}
						}
						
					} else {
						self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response".localized)
				}
				if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
			case .failure(let error):
				if error.errorDescription?.contains("401") ?? false || error.errorDescription?.contains("403") ?? false {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateCreatedEvents(with: refresher)
						} else {
							self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application".localized)
							if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error".localized)
					if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
				}
			}
			
		}
	}
	
	func getQueue(by url: String) {
		delegate?.queueManagerViewModel(self, isLoading: true)
		providerQueue.request(.getQueue(url: url)) { result in
			self.delegate?.queueManagerViewModel(self, isLoading: true)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ModelResponseQueue.self) {
					if answer.success, let queue = answer.response {
						DataManager.shared.addNew(queue, to: FeedKeys.usedFeed) {
							self.delegate?.queueManagerViewModel(self, found: true, queue: QueueCashe(queue: queue), didRecieveMessage: nil)
						}
					} else {
						self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Unexpected response".localized)
				}
			case .failure(let error):
				if error.errorDescription?.contains("401") ?? false || error.errorDescription?.contains("403") ?? false {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.getQueue(by: url)
						} else {
							self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Authorization error, try to restart application".localized)
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Internet connection error".localized)
				}
			}
		}
	}
	
}
