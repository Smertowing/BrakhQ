//
//  AuthManager.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift

final class AuthManager {
	static let shared = AuthManager()
	
	private let provider = MoyaProvider<AuthProvider>()
	private let defaults = KeychainSwift()
	private init() { }
	
	var isAuthenticated: Bool {
		get {
			return defaults.getBool(UserDefaultKeys.isLogged.rawValue) ?? false
		}
	}
	
	var token: String? {
		get {
			return defaults.get(UserDefaultKeys.token.rawValue)
		}
		set {
			if let token = newValue {
				defaults.set(token, forKey: UserDefaultKeys.token.rawValue)
			}
		}
	}
	
	var refreshToken: String? {
		get {
			return defaults.get(UserDefaultKeys.refreshToken.rawValue)
		}
		set {
			if let refreshToken = newValue {
				defaults.set(refreshToken, forKey: UserDefaultKeys.refreshToken.rawValue)
			}
		}
	}
	
	var deviceToken: String? {
		get {
			return defaults.get(UserDefaultKeys.deviceToken.rawValue)
		}
		set {
			if let deviceToken = newValue {
				defaults.set(deviceToken, forKey: UserDefaultKeys.deviceToken.rawValue)
			}
		}
	}
	
	var user: User? {
		get {
			return User(avatar: defaults.get(UserDefaultKeys.avatar.rawValue),
									id: Int(defaults.get(UserDefaultKeys.id.rawValue)!)!,
									name: (defaults.get(UserDefaultKeys.name.rawValue))!,
									email: defaults.get(UserDefaultKeys.email.rawValue),
									username: defaults.get(UserDefaultKeys.username.rawValue))
		}
		set {
			if let username = newValue?.username {
				defaults.set(username, forKey: UserDefaultKeys.username.rawValue)
			}
			if let name = newValue?.name {
				defaults.set(name, forKey: UserDefaultKeys.name.rawValue)
			}
			if let email = newValue?.email {
				defaults.set(email, forKey: UserDefaultKeys.email.rawValue)
			}
			if let id = newValue?.id {
				defaults.set(String(id), forKey: UserDefaultKeys.id.rawValue)
			}
			if let avatar = newValue?.avatar {
				defaults.set(avatar, forKey: UserDefaultKeys.avatar.rawValue)
			}
		}
	}
	
	func login() {
		print(AuthManager.shared.deviceToken as Any)
		let providerNotifications = MoyaProvider<NotificationsAPIProvider>()
		providerNotifications.request(.subscribe) { (result) in
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
		
		defaults.set(true, forKey: UserDefaultKeys.isLogged.rawValue)
	}
	
	func logout() {
		let tempToken = AuthManager.shared.deviceToken
		let providerNotifications = MoyaProvider<NotificationsAPIProvider>()
		providerNotifications.request(.unsubscribe) { (result) in
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
		
		defaults.clear()
		defaults.set(false, forKey: UserDefaultKeys.isLogged.rawValue)
		deviceToken = tempToken
	}
	
	typealias CompletionHandler = (_ success:Bool) -> Void
	
	func update(token tokenType: TokenType, completionHandler: @escaping (CompletionHandler)) {
		if let refreshToken = defaults.get(UserDefaultKeys.refreshToken.rawValue) {
			provider.request(.updateToken(refreshToken: refreshToken, tokenType: tokenType)) { result in
				switch result {
				case .success(let response):
					if let newToken = try? response.map(Token.self) {
						switch tokenType {
						case .authentication:
							self.defaults.set(newToken.token, forKey: UserDefaultKeys.token.rawValue)
						case .refresh:
							self.defaults.set(newToken.token, forKey: UserDefaultKeys.refreshToken.rawValue)
						case .undefined:
							print("undefined token refreshed")
							return completionHandler(false)
						}
						return completionHandler(true)
					}
					return completionHandler(false)
				case .failure(_):
					return completionHandler(false)
				}
			}
		} else {
			return completionHandler(false)
		}
	}

}
