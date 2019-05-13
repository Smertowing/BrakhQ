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
	
}

final class EditEventViewModel {
	
	weak var delegate: EditEventViewModelDelegate?
	let provider = MoyaProvider<QueueAPIProvider>()
	var queue: QueueCashe
	
	init (for queue: QueueCashe) {
		self.queue = queue
	}
	
	func editEvent(name: String?, description: String?, regStart: Date?, eventDate: Date?, regEnd: Date?, placesCount: Int?) {
		
		delegate?.editEventViewModel(self, isLoading: true)
		
		provider.request(.updateQueue(id: queue.id, name: name, description: description, regStart: regStart?.iso8601, eventDate: eventDate?.iso8601, regEnd: regEnd?.iso8601, placesCount: placesCount)) { result in
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
					self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response")
				}
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.editEvent(name: name, description: description, regStart: regStart, eventDate: eventDate, regEnd: regEnd, placesCount: placesCount)
						} else {
							self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
						}
					}
				} else {
					self.delegate?.editEventViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
				}
			}
		}
		
	}
	
}
