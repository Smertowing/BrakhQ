//
//  AuthManager.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya

final class AuthManager {
	static let shared = AuthManager()
	
	private let provider = MoyaProvider<AuthProvider>()
	private let defaults = UserDefaults.standard
	private init() { }
	
	var isAuthenticated: Bool {
		get {
			return defaults.bool(forKey: UserDefaultKeys.isLogged.rawValue)
		}
	}
	
	var token: String? {
		get {
			return defaults.object(forKey: UserDefaultKeys.token.rawValue) as? String
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.token.rawValue)
		}
	}
	
	var refreshToken: String? {
		get {
			return defaults.object(forKey: UserDefaultKeys.refreshToken.rawValue) as? String
		}
		set {
			defaults.set(newValue, forKey: UserDefaultKeys.refreshToken.rawValue)
		}
	}
	
	var user: User? {
		get {
			return User(avatar: defaults.object(forKey: UserDefaultKeys.avatar.rawValue) as? String,
									id: defaults.integer(forKey: UserDefaultKeys.id.rawValue),
									name: (defaults.object(forKey: UserDefaultKeys.name.rawValue) as? String) ?? "",
									email: defaults.object(forKey: UserDefaultKeys.email.rawValue) as? String,
									username: defaults.object(forKey: UserDefaultKeys.username.rawValue) as? String)
		}
		set {
			defaults.set(newValue?.username, forKey: UserDefaultKeys.username.rawValue)
			defaults.set(newValue?.name, forKey: UserDefaultKeys.name.rawValue)
			defaults.set(newValue?.email, forKey: UserDefaultKeys.email.rawValue)
			defaults.set(newValue?.id, forKey: UserDefaultKeys.id.rawValue)
			defaults.set(newValue?.avatar, forKey: UserDefaultKeys.avatar.rawValue)
		}
	}
	
	func login() {
		defaults.set(true, forKey: UserDefaultKeys.isLogged.rawValue)
	}
	
	func logout() {
		defaults.set(false, forKey: UserDefaultKeys.isLogged.rawValue)
	}
	
	typealias CompletionHandler = (_ success:Bool) -> Void
	
	func update(token tokenType: TokenType, completionHandler: @escaping CompletionHandler) {
		if let refreshToken = defaults.object(forKey: UserDefaultKeys.refreshToken.rawValue) as? String {
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
