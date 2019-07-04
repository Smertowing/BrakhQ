//
//  AuthProxy.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

extension NetworkingManager {
	
	func auth(username: String, password: String, result: @escaping (Result<(AuthResponse), NetworkError>) -> Void) {
		authProvider.request(.auth(password: password, username: username)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(AuthResponse.self) else {
					return result(.failure(.invalidResponse))
				}
				return result(.success(answer))
			case .failure(let error):
				if error.response?.statusCode == 400 {
					return result(.failure(.invalidRequest))
				} else {
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func checkToken(_ token: String, result: @escaping (Result<(TokenValidationResponse), NetworkError>) -> Void) {
		authProvider.request(.checkToken(token: token)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(TokenValidationResponse.self) else {
					return result(.failure(.invalidResponse))
				}
				return result(.success(answer))
			case .failure(_):
				return result(.failure(.unknownError))
			}
		}
	}
	
	func updateToken(tokenType: TokenType, refreshToken: String, result: @escaping (Result<(Token), NetworkError>) -> Void) {
		authProvider.request(.updateToken(refreshToken: refreshToken, tokenType: tokenType)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(Token.self) else {
					return result(.failure(.invalidResponse))
				}
				return result(.success(answer))
			case .failure(_):
				return result(.failure(.unknownError))
			}
		}
	}
	
	func authVK(callback: String, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		authProvider.request(.authVK(callback: callback)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
			case .failure(_):
				return result(.failure(.unknownError))
			}
		}
	}
	
}
