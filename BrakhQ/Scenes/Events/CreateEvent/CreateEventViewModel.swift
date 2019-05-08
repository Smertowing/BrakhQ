//
//  CreateEventViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya
import DataCache

protocol CreateEventViewModelDelegate: class {
	
	func createEventViewModel(_ createEventViewModel: CreateEventViewModel, isLoading: Bool)
	func createEventViewModel(_ createEventViewModel: CreateEventViewModel, isSuccess: Bool, didRecieveMessage message: String?)
	
}

final class CreateEventViewModel {
	
	weak var delegate: CreateEventViewModelDelegate?
	let provider = MoyaProvider<QueueAPIProvider>()
	
	func createEvent(name: String, description: String, queueType: QueueType, regStart: Date, eventDate: Date, regEnd: Date, placesCount: Int) {
		
		delegate?.createEventViewModel(self, isLoading: true)
		
		provider.request(.createQueue(name: name, description: description, queueType: queueType.rawValue, regStart: regStart.iso8601, eventDate: eventDate.iso8601, regEnd: regEnd.iso8601, placesCount: placesCount)) { result in
			self.delegate?.createEventViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ModelResponseQueue.self) {
					if answer.success, let queue = answer.response {
						self.addNewQueue(queue)
						self.delegate?.createEventViewModel(self, isSuccess: true, didRecieveMessage: answer.message)
					} else {
						self.delegate?.createEventViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
					}
				}
			case .failure(let error):
				if error.errorCode == 401 {
					
				}
			}
		}
		
	}
	
	private func addNewQueue(_ queue: Queue) {
		
	}
	
}

