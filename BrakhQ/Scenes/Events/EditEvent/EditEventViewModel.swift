//
//  EditEventViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

protocol EditEventViewModelDelegate: class {
	
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, isLoading: Bool)
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, isSuccess: Bool, didRecieveMessage error: NetworkError!)
	func editEventViewModel(_ editEventViewModel: EditEventViewModel, deleted: Bool, didRecieveMessage error: NetworkError!)
}

final class EditEventViewModel {
	
	weak var delegate: EditEventViewModelDelegate?
	var queue: QueueCashe
	
	init (for queue: QueueCashe) {
		self.queue = queue
	}
	
	func deleteAction() {
		
		guard queue.busyPlaces.isEmpty else {
			delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: .invalidRequest)
			return
		}
	
		self.delegate?.editEventViewModel(self, isLoading: true)
		
		NetworkingManager.shared.deleteQueue(queueId: queue.id) { (result) in
			self.delegate?.editEventViewModel(self, isLoading: false)
			switch result {
			case .success(_):
				self.delegate?.editEventViewModel(self, deleted: true, didRecieveMessage: nil)
			case .failure(let error):
				switch error {
				case .invalidCredentials:
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.deleteAction()
						} else {
							self.delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: .invalidCredentials)
						}
					}
				default:
					self.delegate?.editEventViewModel(self, deleted: false, didRecieveMessage: error)
				}
			}
		}
	}
	
	func editEvent(name: String?, description: String?, eventDate: Date?) {
		
		delegate?.editEventViewModel(self, isLoading: true)
		
		NetworkingManager.shared.updateQueue(id: queue.id, name: name, description: description, eventDate: eventDate?.iso8601) { (result) in
			self.delegate?.editEventViewModel(self, isLoading: false)
			switch result {
			case .success(let queue):
				DataManager.shared.addNew(queue, to: FeedKeys.createdFeed) {
					self.delegate?.editEventViewModel(self, isSuccess: true, didRecieveMessage: nil)
				}
			case .failure(let error):
				switch error {
				case .invalidCredentials:
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.editEvent(name: name, description: description, eventDate: eventDate)
						} else {
							self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: .invalidCredentials)
						}
					}
				default:
					self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: error)
				}
			}
		}
		
	}
	
}
