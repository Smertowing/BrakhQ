//
//  UserProxy.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

extension NetworkingManager {
	
	func getUser(id: Int?, username: String?, result: @escaping (Result<(User), NetworkError>) -> Void) {
		if let id = id {
			userProvider.request(.getUser(id: id)) { (answer) in
				switch answer {
				case .success(let response):
					guard let answer = try? response.map(User.self) else {
						return result(.failure(.invalidResponse))
					}
					return result(.success(answer))
				case .failure(let error):
					switch error.response?.statusCode {
					case 400:
						return result(.failure(.invalidRequest))
					case 401:
						return result(.failure(.invalidCredentials))
					case 404:
						return result(.failure(.notFound))
					default:
						return result(.failure(.unknownError))
					}
				}
			}
		} else if let username = username {
			userProvider.request(.getUserByUsername(username: username)) { (answer) in
				switch answer {
				case .success(let response):
					guard let answer = try? response.map(User.self) else {
						return result(.failure(.invalidResponse))
					}
					return result(.success(answer))
				case .failure(let error):
					switch error.response?.statusCode {
					case 400:
						return result(.failure(.invalidRequest))
					case 401:
						return result(.failure(.invalidCredentials))
					case 404:
						return result(.failure(.notFound))
					default:
						return result(.failure(.unknownError))
					}
				}
			}
		} else {
			return result(.failure(.invalidRequest))
		}
	}
	
	func updateUser(name: String, email: String, result: @escaping (Result<(User), NetworkError>) -> Void) {
		userProvider.request(.updateUser(name: name, email: email)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(User.self) else {
					return result(.failure(.invalidResponse))
				}
				return result(.success(answer))
			case .failure(let error):
				switch error.response?.statusCode {
				case 400:
					return result(.failure(.invalidRequest))
				case 401:
					return result(.failure(.invalidCredentials))
				default:
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func updatePassword(password: String, result: @escaping (Result<(User), NetworkError>) -> Void) {
		userProvider.request(.updatePassword(password: password)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(User.self) else {
					return result(.failure(.invalidResponse))
				}
				return result(.success(answer))
			case .failure(let error):
				switch error.response?.statusCode {
				case 400:
					return result(.failure(.invalidRequest))
				case 401:
					return result(.failure(.invalidCredentials))
				default:
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func updateAvatar(avatar: Data, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		userProvider.request(.updateAvatar(avatar: avatar)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
			case .failure(let error):
				switch error.response?.statusCode {
				case 400:
					return result(.failure(.invalidRequest))
				case 401:
					return result(.failure(.invalidCredentials))
				default:
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func getQeuesBy(userId: Int, result: @escaping (Result<(QueuesListResponse), NetworkError>) -> Void) {
		userProvider.request(.getQueuesBy(userId: userId)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(QueuesListResponse.self) else {
					return result(.failure(.invalidResponse))
				}
				return result(.success(answer))
			case .failure(let error):
				switch error.response?.statusCode {
				case 400:
					return result(.failure(.invalidRequest))
				case 404:
					return result(.failure(.notFound))
				default:
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func register(name: String, username: String, password: String, email: String, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		userProvider.request(.register(username: username, password: password, email: email, name: name)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
			case .failure(let error):
				switch error.response?.statusCode {
				case 400:
					return result(.failure(.invalidRequest))
				default:
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
}
