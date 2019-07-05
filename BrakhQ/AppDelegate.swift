//
//  AppDelegate.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import UserNotifications

func getQueryStringParameter(url: URL, param: String) -> String? {
	guard let url = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
	return url.queryItems?.first(where: { $0.name == param })?.value
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		registerForPushNotifications()
		return true
	}
	
	func registerForPushNotifications() {
		UNUserNotificationCenter.current()
			.requestAuthorization(options: [.alert, .sound]) {
				[weak self] granted, error in
				
				print("Permission granted: \(granted)")
				guard granted else { return }
				self?.getNotificationSettings()
		}
	}
	
	func getNotificationSettings() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			guard settings.authorizationStatus == .authorized else { return }
			DispatchQueue.main.async {
				UIApplication.shared.registerForRemoteNotifications()
			}
		}
	}
	
	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
		) {
		let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
		let token = tokenParts.joined()
		
		AuthManager.shared.deviceToken = token
		/*
		print("Device Token: \(token)")

		let providerNotifications = MoyaProvider<NotificationsAPIProvider>()
		providerNotifications.request(.test) { (result) in
			switch result {
			case .success(let response):
				if let answer = try? response.map(ResponseState.self) {
					if answer.success {
						print("success")
					} else {
						print(answer.message as Any)
					}
				} else {
					print("unexpected error")
				}
			case .failure(let error):
				print(error.errorDescription as Any)
			}
		}
*/
		
	}
	
	func application(
		_ application: UIApplication,
		didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register: \(error)")
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		
		let message = url.host?.removingPercentEncoding
		switch message {
		case "auth":
			AuthManager.shared.token = getQueryStringParameter(url: url, param: "token")
			AuthManager.shared.refreshToken = getQueryStringParameter(url: url, param: "refresh_token")
			
			NetworkingManager.shared.getUser(id: nil, username: getQueryStringParameter(url: url, param: "username")!) { (result) in
				switch result {
				case .success(let user):
					AuthManager.shared.user = user
					AuthManager.shared.login()
					let alertController = UIAlertController(title: "Success".localized, message: "You've entered accoount via VK".localized, preferredStyle: .alert)
					let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.destructive, handler: { _ in
						let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabVC")
						self.window?.rootViewController?.present(mainViewController, animated: true)
					})
					alertController.addAction(okAction)
					
					self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
				case .failure(let error):
					switch error {
					case .unknownError:
						self.showErrorAlert(message: "")
					case .invalidCredentials:
						self.showErrorAlert(message: "")
					case .invalidRequest:
						self.showErrorAlert(message: "")
					case .notFound:
						self.showErrorAlert(message: "")
					case .invalidResponse:
						self.showErrorAlert(message: "")
					default:
						self.showErrorAlert(message: "")
					}
				}
			}
		case "queue":
			if let url = getQueryStringParameter(url: url, param: "url") {
				getQueue(by: url)
			}
		default:
			showErrorAlert(message: "Unexpected response".localized)
		}
		
		return true
	}
	
	func getQueue(by url: String) {
		NetworkingManager.shared.getQueue(url: url) { (result) in
			switch result {
			case .success(let queue):
				let storyBoard = UIStoryboard(name: "Event", bundle: nil)
				let viewController = storyBoard.instantiateViewController(withIdentifier: "eventViewController") as! EventViewController
				viewController.viewModel = EventViewModel(for: QueueCashe(queue: queue))
				
				DispatchQueue.global(qos: .background).async {
					while (self.window?.rootViewController as? UITabBarController) == nil {
						sleep(1)
					}
					DispatchQueue.main.async {
						let tabbar = self.window!.rootViewController as! UITabBarController
						tabbar.selectedViewController?.show(viewController, sender: self)
					}
				}
			case .failure(let error):
				switch error {
				case .unknownError:
					self.showErrorAlert(message: "")
				case .invalidRequest:
					self.showErrorAlert(message: "")
				case .notFound:
					self.showErrorAlert(message: "")
				case .invalidResponse:
					self.showErrorAlert(message: "")
				default:
					self.showErrorAlert(message: "")
				}
			}
		}
	}
	
	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Failure".localized, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default))
		self.window?.rootViewController?.present(alert, animated: true, completion: nil)
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}
