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
	
	func eventViewModel(_ eventViewModel: EventViewModel, isLoading: Bool)
	func eventViewModel(_ eventViewModel: EventViewModel, isSuccess: Bool, didRecieveMessage message: String?)
	func eventViewModel(_ eventViewModel: EventViewModel, endRefreshing: Bool)
}

final class EventViewModel {
	
	weak var delegate: EventViewModelDelegate?
	let provider = MoyaProvider<QueueAPIProvider>()
	var queue: QueueCashe

	init (for queue: QueueCashe) {
		self.queue = queue
	}
	
	func updateEvent(refresher: Bool) {
		delegate?.eventViewModel(self, isLoading: true)
		provider.request(.getQueue(url: queue.url)) { result in
			self.delegate?.eventViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ModelResponseQueue.self) {
					if answer.success, let queue = answer.response {
						DataManager.shared.addNewQueue(queue) {
							self.queue = QueueCashe(queue: queue)
							self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
						}
					} else {
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response")
				}
				if refresher { self.delegate?.eventViewModel(self, endRefreshing: true) }
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateEvent(refresher: refresher)
						} else {
							self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
							if refresher { self.delegate?.eventViewModel(self, endRefreshing: true) }
						}
					}
				} else {
					self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
					if refresher { self.delegate?.eventViewModel(self, endRefreshing: true) }
				}
			}
		}
	}
	
	func interactPlace(_ site: Int) {
		delegate?.eventViewModel(self, isLoading: true)
		provider.request(.takeQueueSite(site: site, queueId: self.queue.id)) { success in
			
		}
	}
	
}
