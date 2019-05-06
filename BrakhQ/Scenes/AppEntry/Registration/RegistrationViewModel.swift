//
//  RegistrationViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya

protocol RegistrationViewModelDelegate: class {
	
	func registrationViewModel(_ registrationViewModel: RegistrationViewModel, isLoading: Bool)
	
	func registrationViewModel(_ registrationViewModel: RegistrationViewModel, isSuccess: Bool, didRecieveMessage message: ResponseStateRegistration?)
	
}

final class RegistrationViewModel {
	weak var delegate: RegistrationViewModelDelegate?
	
	let provider = MoyaProvider<UserAPIProvider>()
	
	func register(username: String, password: String, email: String, name: String) {
		
		delegate?.registrationViewModel(self, isLoading: true)
		
		provider.request(.register(username: username, password: password, email: email, name: name)) { (result) in
			self.delegate?.registrationViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				do {
					let responseState = try response.map(ResponseStateRegistration.self)
					self.delegate?.registrationViewModel(self, isSuccess: true, didRecieveMessage: responseState)
				} catch {
					print(":(")
					self.delegate?.registrationViewModel(self, isSuccess: false, didRecieveMessage: nil)
				}
			case .failure(_):
				print(result.error as Any)
				self.delegate?.registrationViewModel(self, isSuccess: false, didRecieveMessage: nil)
			}
		}
	}
	
}
