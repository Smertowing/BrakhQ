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
	
	func showAlert(title: String, message: String, action: (() -> Void)? = nil) {
		let alert = UIAlertController(title: "Failure".localized, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default))
		self.present(alert, animated: true, completion: nil)
	}
	
	func showErrorAlert(_ error: NetworkError) {
		switch error {
		case .unknownError:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .connectionError:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .invalidCredentials:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .invalidRequest:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .notFound:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .invalidResponse:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .serverError:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .serverUnavailable:
			self.showAlert(title: "Failure".localized, message: "".localized)
		case .timeOut:
			self.showAlert(title: "Failure".localized, message: "".localized)
		default:
			self.showAlert(title: "Failure".localized, message: "".localized)
		}
	}
	
	func segueToAppllication() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let mainTabViewController = storyBoard.instantiateViewController(withIdentifier: "mainTabVC") as! UITabBarController
		appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
		appDelegate.window?.rootViewController = mainTabViewController
	}
	
	func segueToStartScreen() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let startController = storyBoard.instantiateViewController(withIdentifier: "startVC") as! UINavigationController
		appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
		appDelegate.window?.rootViewController = startController
	}

	
}

extension UIView {
	@IBInspectable var ignoresInvertColors: Bool {
		get {
			if #available(iOS 11.0, *) {
				return accessibilityIgnoresInvertColors
			}
			return false
		}
		set {
			if #available(iOS 11.0, *) {
				accessibilityIgnoresInvertColors = newValue
			}
		}
	}
}
