//
//  LaunchViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
	
	@IBOutlet weak var logoImageView: UIImageView!
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		UIView.transition(with: self.logoImageView,
											duration: 0.75,
											options: .transitionCrossDissolve,
											animations: { self.logoImageView.image = #imageLiteral(resourceName: "BQLabelBlue") },
											completion: nil)
		self.loadingIndicator.startAnimating()

		guard AuthManager.shared.isAuthenticated, let refreshToken = AuthManager.shared.refreshToken else {
			AuthManager.shared.logout()
			segueToStartScreen()
			return
		}
		
		self.loadingIndicator.startAnimating()
		NetworkingManager.shared.checkToken(refreshToken) { (result) in
			self.loadingIndicator.stopAnimating()
			switch result {
			case .success(let tokenValidation):
				guard tokenValidation.isValid, !tokenValidation.isExpired else {
					AuthManager.shared.logout()
					self.segueToStartScreen()
					return
				}
				let diffDate = Date(dateString: tokenValidation.expiresDate, format: Date.iso8601Format)
				if diffDate.timeIntervalSinceNow < 60*60*24*7 {
					AuthManager.shared.update(token: .refresh) { success in
						print(success)
					}
				}
				AuthManager.shared.update(token: .authentication) { success in
					print(success)
				}
				self.segueToAppllication()
				return
			case .failure(_):
				self.segueToAppllication()
				self.loadingIndicator.stopAnimating()
				return
			}
		}
	}

}
