//
//  EditEventViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya

protocol EditEventViewModelDelegate: class {
	
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, isLoading: Bool)
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, isSuccess: Bool, didRecieveMessage message: String?)
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, deleted: Bool, didRecieveMessage message: String?)
}

final class EditEventViewModel {
	
	weak var delegate: EditEventViewModelDelegate?
	let provider = MoyaProvider<QueueAPIProvider>()
	var queue: QueueCashe
	
	init (for queue: QueueCashe) {
		self.queue = queue
	}
	
	func deleteAction() {
		if queue.busyPlaces.isEmpty {
			self.delegate?.editEventViewModel(self, isLoading: true)
			provider.request(.delete(queueId: queue.id)) { result in
				self.delegate?.editEventViewModel(self, isLoading: false)
				switch result {
				case .success(let response):
					if let answer = try? response.map(ResponseState.self) {
						if answer.success {
								self.delegate?.editEventViewModel(self, deleted: true, didRecieveMessage: answer.message)
						} else {
							self.delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: answer.message)
						}
					} else {
						self.delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: "Unexpected response".localized)
					}
				case .failure(let error):
					if error.errorDescription?.contains("401") ?? false || error.errorDescription?.contains("403") ?? false {
						AuthManager.shared.update(token: .authentication) { success in
							if success {
								self.deleteAction()
							} else {
								self.delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: "Authorization error, try to restart application".localized)
							}
						}
					} else {
						self.delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: "Internet connection error".localized)
					}
				}
			}
		} else {
			delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: "Queue is not empty".localized)
		}
	}
	
	func editEvent(name: String?, description: String?, eventDate: Date?) {
		
		delegate?.editEventViewModel(self, isLoading: true)
		
		provider.request(.updateQueue(id: queue.id, name: name, description: description, eventDate: eventDate?.iso8601)) { result in
			self.delegate?.editEventViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ModelResponseQueue.self) {
					if answer.success, let queue = answer.response {
						DataManager.shared.addNew(queue, to: FeedKeys.createdFeed) {
							self.delegate?.editEventViewModel(self, isSuccess: true, didRecieveMessage: answer.message)
						}
					} else {
						self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response".localized)
				}
			case .failure(let error):
				if error.errorDescription?.contains("401") ?? false || error.errorDescription?.contains("403") ?? false {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.editEvent(name: name, description: description, eventDate: eventDate)
						} else {
							self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application".localized)
						}
					}
				} else {
					self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error".localized)
				}
			}
		}
		
	}
	
}
