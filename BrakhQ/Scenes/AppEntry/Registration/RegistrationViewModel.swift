//
//  RegistrationViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

protocol RegistrationViewModelDelegate: class {
	
	func registrationViewModel(_ registrationViewModel: RegistrationViewModel, isLoading: Bool)
	func registrationViewModel(_ registrationViewModel: RegistrationViewModel, isSuccess: Bool, didRecieveMessage error: NetworkError!)
	
}

final class RegistrationViewModel {
	
	weak var delegate: RegistrationViewModelDelegate?

	func register(username: String, password: String, email: String, name: String) {
		
		delegate?.registrationViewModel(self, isLoading: true)
		
		NetworkingManager.shared.register(name: name, username: username, password: password, email: email) { (result) in
			self.delegate?.registrationViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				self.delegate?.registrationViewModel(self, isSuccess: response, didRecieveMessage: nil)
			case .failure(let error):
				self.delegate?.registrationViewModel(self, isSuccess: false, didRecieveMessage: error)
			}
		}
		
	}
	
}
