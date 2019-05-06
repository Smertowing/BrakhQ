//
//  UIViewControllerExt.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func showErrorAlert(errorsLog: [String : String]?) {
		
		let customAlert = UIStoryboard(name: "FailureInfoView", bundle: nil).instantiateViewController(withIdentifier: "failureInfoView") as! FailureInfoView
		customAlert.providesPresentationContextTransitionStyle = true
		customAlert.definesPresentationContext = true
		customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
		customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
		
		customAlert.errors = errorsLog
		
		if let tabController = tabBarController {
			tabController.present(customAlert, animated: true, completion: nil)
		} else if let navController = navigationController {
			navController.present(customAlert, animated: true, completion: nil)
		} else {
			self.present(customAlert, animated: true, completion: nil)
		}
		
	}
}

