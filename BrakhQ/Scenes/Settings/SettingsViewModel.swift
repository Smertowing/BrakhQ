//
//  SettingsViewModel.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/17/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

final class SettingsViewModel {
	
	func getUpdateViewController() -> UIViewController {
		
		let viewModel = UpdateProfileViewModel()
		return UpdateProfileViewController(viewModel: viewModel)
	}
	
}
