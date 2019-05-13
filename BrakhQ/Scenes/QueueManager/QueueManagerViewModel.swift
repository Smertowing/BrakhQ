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
	
	var queues: [QueueCashe] = DataManager.shared.feed.queues
	
	func filterQueues(restrictToManaged: Bool) {
		queues = DataManager.shared.feed.queues
		if restrictToManaged {
			queues = queues.filter { (queue) -> Bool in
				return queue.owner.id == AuthManager.shared.user?.id
			}
		}
		queues.reverse()
		delegate?.queueManagerViewModel(self, reload: true)
	}
	
	func searchBy(_ link: String) {
		do {
			let regex = try NSRegularExpression(pattern: "queue.brakh.men/[a-zA-Z0-9]+")
			let results = regex.matches(in: link,
																	range: NSRange(link.startIndex..., in: link))
			var links = results.map {
				String(link[Range($0.range, in: link)!])
			}
			if links.isEmpty {
				self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Wrong input")
			} else {
				var url: String = links[0]
				url.removeFirst("queue.brakh.men/".count)
				
				getQueue(by: url)
			}
		} catch {
			self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Wrong input")
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
						for queue in queues {
							DataManager.shared.addNewQueue(queue) {
								self.delegate?.queueManagerViewModel(self, isSuccess: true, didRecieveMessage: answer.message)
							}
						}
						self.updateCreatedEvents(with: refresher)
					} else {
						self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
						if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response")
					if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
				}
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateUsedEvents(with: refresher)
						} else {
							self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
							if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
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
						for queue in queues {
							DataManager.shared.addNewQueue(queue) {
								self.delegate?.queueManagerViewModel(self, isSuccess: true, didRecieveMessage: answer.message)
							}
						}
						
					} else {
						self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response")
				}
				if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateCreatedEvents(with: refresher)
						} else {
							self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
							if refresher { self.delegate?.queueManagerViewModel(self, endRefreshing: true) }
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
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
						DataManager.shared.addNewQueue(queue) {
							self.delegate?.queueManagerViewModel(self, found: true, queue: QueueCashe(queue: queue), didRecieveMessage: nil)
						}
					} else {
						self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Unexpected response")
				}
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.getQueue(by: url)
						} else {
							self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Authorization error, try to restart application")
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, found: false, queue: nil, didRecieveMessage: "Internet connection error")
				}
			}
		}
	}
	
}
