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
	func eventViewModel(_ eventViewModel: EventViewModel, endConfigurating: Bool)
}

final class EventViewModel {
	
	weak var delegate: EventViewModelDelegate?
	let provider = MoyaProvider<QueueAPIProvider>()
	var queue: QueueCashe
	var places: [SiteConfig] = []
	
	init (for queue: QueueCashe) {
		self.queue = queue
		for i in 1...queue.placesCount {
			places.append(SiteConfig(accessability: .free,
															 username: "Free",
															 position: i,
															 interactable: true))
		}
		setPlaceConfigs()
	}
	
	func setPlaceConfigs() {
		places = []
		for i in 1...queue.placesCount {
			places.append(SiteConfig(accessability: .free,
															 username: "Free",
															 position: i,
															 interactable: true))
		}
		
		
		if queue.regActive {
			var interactable = true
			
			queue.busyPlaces.forEach { (placeCache) in
				places[placeCache.place-1].username = placeCache.user!.name
				if placeCache.user!.id == AuthManager.shared.user!.id {
					interactable = false
					places[placeCache.place-1].accessability = .release
				} else {
					places[placeCache.place-1].accessability = .engaged
				}
			}
		
			places = places.map { (place) -> SiteConfig in
				return SiteConfig(accessability: place.accessability,
													username: place.username,
													position: place.position,
													interactable: place.accessability == .release ? true : interactable)
			}
		} else {
			places = places.map { (place) -> SiteConfig in
				return SiteConfig(accessability: place.accessability,
													username: place.username,
													position: place.position,
													interactable: false)
			}
		}
		
		delegate?.eventViewModel(self, endConfigurating: true)
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
		
		switch places[site-1].accessability {
		case .release:
			provider.request(.freeUpQueueSite(queueId: queue.id)) { result in
				self.delegate?.eventViewModel(self, isLoading: false)
				switch result {
				case .success(let response):
					if let answer = try? response.map(ResponseState.self) {
						if answer.success {
							self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
							self.updateEvent(refresher: false)
						} else {
							self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
						}
					} else {
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response")
					}
				case .failure(let error):
					if error.errorCode == 401 {
						AuthManager.shared.update(token: .authentication) { success in
							if success {
								self.interactPlace(site)
							} else {
								self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
							}
						}
					} else {
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
					}
				}
			}
		case .engaged:
			break
		case .free:
			provider.request(.takeQueueSite(site: site, queueId: queue.id)) { result in
				self.delegate?.eventViewModel(self, isLoading: false)
				switch result {
				case .success(let response):
					if let answer = try? response.map(ResponseState.self) {
						if answer.success {
							self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
							self.updateEvent(refresher: false)
						} else {
							self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
						}
					} else {
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response")
					}
				case .failure(let error):
					if error.errorCode == 401 {
						AuthManager.shared.update(token: .authentication) { success in
							if success {
								self.interactPlace(site)
							} else {
								self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
							}
						}
					} else {
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
					}
				}
			}
		}
	}
	
	func takeSequent() {
		delegate?.eventViewModel(self, isLoading: true)
		provider.request(.takeFirstQueueSite(queueId: queue.id)) { result in
			self.delegate?.eventViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(ResponseState.self) {
					if answer.success {
						self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
						self.updateEvent(refresher: false)
					} else {
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: answer.message)
					}
				} else {
					self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Unexpected response")
				}
			case .failure(let error):
				if error.errorCode == 401 {
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.takeSequent()
						} else {
							self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Authorization error, try to restart application")
						}
					}
				} else {
					self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: "Internet connection error")
				}
			}
		}
	}
	
}
