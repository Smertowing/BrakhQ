//
//  EventViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya

protocol EventViewModelDelegate: class {
	
	func eventViewModelDelegate(_ eventViewModelDelegate: EventViewModel, isLoading: Bool)
	func eventViewModelDelegate(_ eventViewModelDelegate: EventViewModel, isSuccess: Bool, didRecieveMessage message: String?)
	
}

final class EventViewModel {
	
	weak var delegate: EventViewModelDelegate?
	let provider = MoyaProvider<QueueAPIProvider>()
	var queue: QueueCashe

	init (for queue: QueueCashe) {
		self.queue = queue
	}
	
	func updateEvent() {
		delegate?.eventViewModelDelegate(self, isLoading: true)
		provider.request(.getQueue(url: queue.url)) { result in
			self.delegate?.eventViewModelDelegate(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ModelResponseQueue.self) {
					if answer.success, let queue = answer.response {
						DataManager.shared.addNewQueue(queue) {
							self.queue = QueueCashe(queue: queue)
							self.delegate?.eventViewModelDelegate(self, isSuccess: true, didRecieveMessage: nil)
						}
					} else {
						self.delegate?.eventViewModelDelegate(self, isSuccess: false, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.eventViewModelDelegate(self, isSuccess: false, didRecieveMessage: "Unexpected response")
				}
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateEvent()
						} else {
							self.delegate?.eventViewModelDelegate(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
						}
					}
				} else {
					self.delegate?.eventViewModelDelegate(self, isSuccess: false, didRecieveMessage: "Internet connection error")
				}
			}
		}
	}
	
}
