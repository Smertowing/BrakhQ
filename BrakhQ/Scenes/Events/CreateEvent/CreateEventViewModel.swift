//
//  CreateEventViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

protocol CreateEventViewModelDelegate: class {
	
	func createEventViewModel(_ createEventViewModel: CreateEventViewModel, isLoading: Bool)
	func createEventViewModel(_ createEventViewModel: CreateEventViewModel, isSuccess: Bool, didRecieveMessage error: NetworkError!)
	
}

final class CreateEventViewModel {
	
	weak var delegate: CreateEventViewModelDelegate?
	
	func createEvent(name: String, description: String?, queueType: QueueType, regStart: Date, eventDate: Date, regEnd: Date, placesCount: Int) {
		
		delegate?.createEventViewModel(self, isLoading: true)
		
		NetworkingManager.shared.createQueue(name: name, description: description, queueType: queueType.rawValue, regStart: regStart.iso8601, eventDate: eventDate.iso8601, regEnd: regEnd.iso8601, placesCount: placesCount) { (result) in
			self.delegate?.createEventViewModel(self, isLoading: false)
			switch result {
			case .success(let queue):
				DataManager.shared.addNew(queue, to: FeedKeys.createdFeed) {
					self.delegate?.createEventViewModel(self, isSuccess: true, didRecieveMessage: nil)
				}
			case .failure(let error):
				switch error {
				case .invalidCredentials:
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.createEvent(name: name, description: description, queueType: queueType, regStart: regStart, eventDate: eventDate, regEnd: regEnd, placesCount: placesCount)
						} else {
							self.delegate?.createEventViewModel(self, isSuccess: false, didRecieveMessage: .invalidCredentials)
						}
					}
				default:
					self.delegate?.createEventViewModel(self, isSuccess: false, didRecieveMessage: error)
				}
			}
		}
	}
	
}

