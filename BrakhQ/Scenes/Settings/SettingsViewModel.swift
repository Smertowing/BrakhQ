//
//  SettingsViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

protocol SettingsViewModelDelegate: class {
	
	func settingsViewModel(_ settingsViewModel: SettingsViewModel, readyToExit: Bool)
	
}

final class SettingsViewModel {
	
	weak var delegate: SettingsViewModelDelegate?
	
	func getUpdateViewController() -> UIViewController {
		let viewModel = UpdateProfileViewModel()
		return UpdateProfileViewController(viewModel: viewModel)
	}
	
	func exit() {
		
		UserDefaults.standard.set(nil, forKey: UserDefaultKeys.username.rawValue)
		UserDefaults.standard.set(nil, forKey: UserDefaultKeys.name.rawValue)
		UserDefaults.standard.set(nil, forKey: UserDefaultKeys.email.rawValue)
		UserDefaults.standard.set(nil, forKey: UserDefaultKeys.id.rawValue)
		UserDefaults.standard.set(nil, forKey: UserDefaultKeys.avatar.rawValue)
		UserDefaults.standard.set(nil, forKey: UserDefaultKeys.token.rawValue)
		UserDefaults.standard.set(nil, forKey: UserDefaultKeys.refreshToken.rawValue)
		UserDefaults.standard.set(false, forKey: UserDefaultKeys.isLogged.rawValue)
		
		delegate?.settingsViewModel(self, readyToExit: true)
		
	}
	
}
