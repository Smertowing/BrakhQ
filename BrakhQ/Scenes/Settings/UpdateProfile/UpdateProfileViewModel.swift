//
//  UpdateProfileViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

protocol UpdateProfileViewModelDelegate: class {
	
	func updateProfileViewModel(_ updateProfileViewModel: UpdateProfileViewModel, isLoading: Bool)
	
	func updateProfileViewModel(_ updateProfileViewModel: UpdateProfileViewModel, updateSuccessfull: Bool)
	
}

final class UpdateProfileViewModel {
	
	weak var delegate: UpdateProfileViewModelDelegate?
	
	let providerUser = MoyaProvider<UserAPIProvider>()
	let providerAuth = MoyaProvider<AuthProvider>()
	
	func changeProfile(name: String, email: String) {
		
		delegate?.updateProfileViewModel(self, isLoading: true)
		
		providerUser.request(.updateUser(name: name, email: email)) { result in
			self.delegate?.updateProfileViewModel(self, isLoading: false)
			switch result {
			case .success(_):
				UserDefaults.standard.set(name, forKey: UserDefaultKeys.name.rawValue)
				UserDefaults.standard.set(email, forKey: UserDefaultKeys.email.rawValue)
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: true)
			case .failure(_):
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: false)
			}
		}
		
	}
	
	func changePassword(currentPassword: String, newPassword: String) {
		
		delegate?.updateProfileViewModel(self, isLoading: true)
		
		providerAuth.request(.auth(password: currentPassword, username: UserDefaults.standard.object(forKey: UserDefaultKeys.username.rawValue) as! String)) { (result) in
			self.delegate?.updateProfileViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				if let answer = try? response.map(AuthResponse.self) {
					if let token = answer.token, let refreshToken = answer.refreshToken {
						UserDefaults.standard.set(token, forKey: UserDefaultKeys.token.rawValue)
						UserDefaults.standard.set(refreshToken, forKey: UserDefaultKeys.refreshToken.rawValue)
						self.updatePassword(password: newPassword)
					} else {
						self.delegate?.updateProfileViewModel(self, updateSuccessfull: false)
					}
				} else {
					self.delegate?.updateProfileViewModel(self, updateSuccessfull: false)
				}
			case .failure(_):
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: false)
			}
		}
		
	}
	
	private func updatePassword(password: String) {
		
		delegate?.updateProfileViewModel(self, isLoading: true)
		
		providerUser.request(.updatePassword(password: password)) { result in
			self.delegate?.updateProfileViewModel(self, isLoading: false)
			switch result {
			case .success(_):
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: true)
			case .failure(_):
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: false)
			}
		}
		
	}
	
}
