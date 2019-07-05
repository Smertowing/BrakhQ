//
//  LoginViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: class {
	
	func loginViewModel(_ loginViewModel: LoginViewModel, isLoading: Bool)
	func loginViewModel(_ loginViewModel: LoginViewModel, isSuccess: Bool, user: User!, error: NetworkError!)
	
}

final class LoginViewModel {
	
	weak var delegate: LoginViewModelDelegate?
	
	func login(username: String, password: String) {
		
		delegate?.loginViewModel(self, isLoading: true)
		
		NetworkingManager.shared.auth(username: username, password: password) { (result) in
			self.delegate?.loginViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				AuthManager.shared.token = response.token
				AuthManager.shared.refreshToken = response.refreshToken
				self.getUserBy(username: username)
			case .failure(let error):
				self.delegate?.loginViewModel(self, isSuccess: false, user: nil, error: error)
			}
		}
	}
	
	func getUserBy(username: String) {
		
		self.delegate?.loginViewModel(self, isLoading: true)
		
		NetworkingManager.shared.getUser(id: nil, username: username) { (result) in
			self.delegate?.loginViewModel(self, isLoading: false)
			switch result {
			case .success(let user):
				AuthManager.shared.user = user
				AuthManager.shared.login()
				self.delegate?.loginViewModel(self, isSuccess: true, user: user, error: nil)
			case .failure(let error):
				self.delegate?.loginViewModel(self, isSuccess: false, user: nil, error: error)
			}
		}
		
	}
	
}
