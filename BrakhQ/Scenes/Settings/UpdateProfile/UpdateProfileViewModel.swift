//
//  UpdateProfileViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

protocol UpdateProfileViewModelDelegate: class {
	
	func updateProfileViewModel(_ updateProfileViewModel: UpdateProfileViewModel, isLoading: Bool)
	func updateProfileViewModel(_ updateProfileViewModel: UpdateProfileViewModel, updateSuccessfull: Bool)
	
}

final class UpdateProfileViewModel {
	
	weak var delegate: UpdateProfileViewModelDelegate?
	
	func changeProfile(name: String, email: String) {
		
		delegate?.updateProfileViewModel(self, isLoading: true)
		NetworkingManager.shared.updateUser(name: name, email: email) { (result) in
			self.delegate?.updateProfileViewModel(self, isLoading: false)
			switch result {
			case .success(let user):
				AuthManager.shared.user = User(avatar: user.avatar,
																			 id: user.id,
																			 name: name,
																			 email: email,
																			 username: user.username)
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: true)
			case .failure(_):
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: false)
			}
		}
	}
	
	func changePassword(currentPassword: String, newPassword: String) {
		
		delegate?.updateProfileViewModel(self, isLoading: true)
		
		NetworkingManager.shared.auth(username: AuthManager.shared.user?.username ?? "", password: currentPassword) { (result) in
			self.delegate?.updateProfileViewModel(self, isLoading: false)
			switch result {
			case .success(let response):
				AuthManager.shared.token = response.token
				AuthManager.shared.refreshToken = response.refreshToken
				self.updatePassword(password: newPassword)
			case .failure(_):
				self.delegate?.updateProfileViewModel(self, updateSuccessfull: false)
			}
		}
	}
	
	func updatePassword(password: String) {
		
		delegate?.updateProfileViewModel(self, isLoading: true)
		
		NetworkingManager.shared.updatePassword(password: password) { (result) in
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
