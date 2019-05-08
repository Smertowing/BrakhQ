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
	
}

final class QueueManagerViewModel {
	
	weak var delegate: QueueManagerViewModelDelegate?
	let provider = MoyaProvider<UserAPIProvider>()
	
	func updateUsedEvents() {
		delegate?.queueManagerViewModel(self, isLoading: true)
		provider.request(.getQueuesUsedBy(userId: AuthManager.shared.user?.id ?? -1)) { result in
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
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateUsedEvents()
						} else {
							self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
				}
			}
			
		}
	}
	
	func updateCreatedEvents() {
		delegate?.queueManagerViewModel(self, isLoading: true)
		provider.request(.getQueuesCreatedBy(userId: AuthManager.shared.user?.id ?? -1)) { result in
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
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateCreatedEvents()
						} else {
							self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
						}
					}
				} else {
					self.delegate?.queueManagerViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
				}
			}
			
		}
	}
	
}
