//
//  LaunchViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

class LaunchViewController: UIViewController {

	let provider = MoyaProvider<AuthProvider>()
	
	@IBOutlet weak var logoImageView: UIImageView!
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DispatchQueue.main.async() {
			UIView.transition(with: self.logoImageView,
												duration: 0.75,
												options: .beginFromCurrentState,
												animations: { self.logoImageView.image = #imageLiteral(resourceName: "BQLabelBlue") },
												completion: nil)
			self.loadingIndicator.startAnimating()
		}
		
		if AuthManager.shared.isAuthenticated {
			provider.request(.checkToken(token: AuthManager.shared.refreshToken ?? "")) { result in
				if case .success(let response) = result {
					if let answer = try? response.map(TokenValidationResponse.self) {
						if answer.valid, let expired = answer.expired, let expires = answer.expires {
							if expired {
								AuthManager.shared.logout()
								self.segueToStartScreen()
							}
							let diffDate = Date(dateString: expires, format: Date.iso8601Format)
							if diffDate.timeIntervalSinceNow < 60*60*24*7 {
								AuthManager.shared.update(token: .refresh) { success in
									print(success)
								}
							}
							AuthManager.shared.update(token: .authentication) { success in
								print(success)
							}
							self.segueToAppllication()
						} else {
							AuthManager.shared.logout()
							self.segueToStartScreen()
						}
					}
				}
				self.segueToAppllication()
				self.loadingIndicator.stopAnimating()
			}
		} else {
			segueToStartScreen()
			loadingIndicator.stopAnimating()
		}
	}
	
	
	func segueToAppllication() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let mainTabViewController = storyboard!.instantiateViewController(withIdentifier: "mainTabVC") as! UITabBarController
		appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
		appDelegate.window?.rootViewController = mainTabViewController
	}
	
	func segueToStartScreen() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let startController = storyboard!.instantiateViewController(withIdentifier: "startVC") as! UINavigationController
		appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
		appDelegate.window?.rootViewController = startController
	}

}
