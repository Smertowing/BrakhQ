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
		
		AuthManager.shared.logout()
		
		delegate?.settingsViewModel(self, readyToExit: true)
		
	}
	
}
