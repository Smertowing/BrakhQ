//
//  EventViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

protocol EventViewModelDelegate: class {
	
	func eventViewModel(_ eventViewModel: EventViewModel, isLoading: Bool)
	func eventViewModel(_ eventViewModel: EventViewModel, isSuccess: Bool, didRecieveMessage error: NetworkError!)
	func eventViewModel(_ eventViewModel: EventViewModel, endRefreshing: Bool)
	func eventViewModel(_ eventViewModel: EventViewModel, endConfigurating: Bool)
}

final class EventViewModel {
	
	weak var delegate: EventViewModelDelegate?
	var queue: QueueCashe
	var places: [SiteConfig] = []
	
	init (for queue: QueueCashe) {
		self.queue = queue
		for i in 1...queue.placesCount {
			places.append(SiteConfig(accessability: .free,
															 username: "Free".localized,
															 position: i,
															 interactable: true))
		}
		setPlaceConfigs()
	}
	
	func setPlaceConfigs() {
		places = []
		for i in 1...queue.placesCount {
			places.append(SiteConfig(accessability: .free,
															 username: "Free".localized,
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
													interactable: place.accessability == .release ? true : place.accessability == .engaged ? false : interactable )
			}
		} else {
			queue.busyPlaces.forEach { (placeCache) in
				places[placeCache.place-1].username = placeCache.user!.name
				if placeCache.user!.id == AuthManager.shared.user!.id {
					places[placeCache.place-1].accessability = .release
				} else {
					places[placeCache.place-1].accessability = .engaged
				}
			}
			
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
		
		NetworkingManager.shared.getQueue(url: queue.url) { (result) in
			self.delegate?.eventViewModel(self, isLoading: false)
			switch result {
			case .success(let queue):
				self.queue = QueueCashe(queue: queue)
				self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
			case .failure(let error):
				switch error {
				case .invalidCredentials:
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.updateEvent(refresher: refresher)
						} else {
							self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: .invalidCredentials)
							if refresher { self.delegate?.eventViewModel(self, endRefreshing: true) }
						}
					}
				default:
					self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: error)
					if refresher { self.delegate?.eventViewModel(self, endRefreshing: true) }
				}
			}
		}
	}
	
	func interactPlace(_ site: Int) {
		delegate?.eventViewModel(self, isLoading: true)
		
		switch places[site-1].accessability {
		case .release:
			NetworkingManager.shared.freePlace(queueId: queue.id) { (result) in
				self.delegate?.eventViewModel(self, isLoading: false)
				switch result {
				case .success(_):
					self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
					self.updateEvent(refresher: false)
				case .failure(let error):
					switch error {
					case .invalidCredentials:
						AuthManager.shared.update(token: .authentication) { success in
							if success {
								self.interactPlace(site)
							} else {
								self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: .invalidCredentials)
							}
						}
					default:
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: error)
					}
				}
			}
		case .engaged:
			break
		case .free:
			NetworkingManager.shared.takePlace(queueId: queue.id, place: site) { (result) in
				self.delegate?.eventViewModel(self, isLoading: false)
				switch result {
				case .success(_):
					self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
					self.updateEvent(refresher: false)
				case .failure(let error):
					switch error {
					case .invalidCredentials:
						AuthManager.shared.update(token: .authentication) { success in
							if success {
								self.interactPlace(site)
							} else {
								self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: .invalidCredentials)
							}
						}
					default:
						self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: error)
					}
				}
			}
		}
	}
	
	func takeSequent() {
		delegate?.eventViewModel(self, isLoading: true)
		NetworkingManager.shared.takeFirstPlace(queueId: queue.id) { (result) in
			self.delegate?.eventViewModel(self, isLoading: false)
			switch result {
			case .success(_):
				self.delegate?.eventViewModel(self, isSuccess: true, didRecieveMessage: nil)
				self.updateEvent(refresher: false)
			case .failure(let error):
				switch error {
				case .invalidCredentials:
					AuthManager.shared.update(token: .authentication) { success in
						if success {
							self.takeSequent()
						} else {
							self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: .invalidCredentials)
						}
					}
				default:
					self.delegate?.eventViewModel(self, isSuccess: false, didRecieveMessage: error)
				}
			}
		}
	}
	
}

