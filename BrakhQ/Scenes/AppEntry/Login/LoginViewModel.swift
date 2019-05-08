//
//  LoginViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya

protocol LoginViewModelDelegate: class {
	
	func loginViewModel(_ loginViewModel: LoginViewModel, isLoading: Bool)
	
	func loginViewModel(_ loginViewModel: LoginViewModel, isSuccess: Bool, user: User?)
	
}

final class LoginViewModel {
	
	weak var delegate: LoginViewModelDelegate?
	let providerAuth = MoyaProvider<AuthProvider>()
	let providerUser = MoyaProvider<UserAPIProvider>()
	
	func login(username: String, password: String) {
		
		delegate?.loginViewModel(self, isLoading: true)
		
		providerAuth.request(.auth(password: password, username: username)) { (result) in
			self.delegate?.loginViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(AuthResponse.self) {
					if let token = answer.token, let refreshToken = answer.refreshToken {
						AuthManager.shared.token = token
						AuthManager.shared.refreshToken = refreshToken
						self.getUserBy(username: username, token: token)
					} else {
						self.delegate?.loginViewModel(self, isSuccess: false, user: nil)
					}
				} else {
					self.delegate?.loginViewModel(self, isSuccess: false, user: nil)
				}
			case .failure(_):
				self.delegate?.loginViewModel(self, isSuccess: false, user: nil)
			}
		}
		
	}
	
	private func getUserBy(username: String, token: String) {
		
		self.delegate?.loginViewModel(self, isLoading: true)
		
		providerUser.request(.getUserByUsername(username: username)) { result in
			self.delegate?.loginViewModel(self, isLoading: false)
			if case .success(let response) = result  {
				if let answer = try? response.map(ModelResponseUser.self) {
					if let user = answer.response {
						AuthManager.shared.user = user
						AuthManager.shared.login()
						self.delegate?.loginViewModel(self, isSuccess: true, user: user)
					} else {
						self.delegate?.loginViewModel(self, isSuccess: false, user: nil)
					}
				} else {
					self.delegate?.loginViewModel(self, isSuccess: false, user: nil)
				}
			} else {
				self.delegate?.loginViewModel(self, isSuccess: false, user: nil)
			}
		}
	}
	
}
