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
			if let token = newValue {
				defaults.set(token, forKey: UserDefaultKeys.refreshToken.rawValue)
			}
		}
	}//Int(defaults.getData(UserDefaultKeys.id.rawValue)
	
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
		defaults.set(true, forKey: UserDefaultKeys.isLogged.rawValue)
	}
	
	func logout() {
		defaults.clear()
		defaults.set(false, forKey: UserDefaultKeys.isLogged.rawValue)
	}
	
	typealias CompletionHandler = (_ success:Bool) -> Void
	
	func update(token tokenType: TokenType, completionHandler: @escaping (CompletionHandler)) {
		if let refreshToken = defaults.get(UserDefaultKeys.refreshToken.rawValue) {
			provider.request(.updateToken(refreshToken: refreshToken, tokenType: tokenType)) { result in
				if case .success(let response) = result {
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
				}
			}
		} else {
			return completionHandler(false)
		}
	}

}
