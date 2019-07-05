//
//  QueueProxy.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

extension NetworkingManager {
	
	func getQueue(url: String, result: @escaping (Result<(Queue), NetworkError>) -> Void) {
		queueProvider.request(.getQueue(url: url)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(Queue.self) else {
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
	
	func createQueue(name: String, description: String?, queueType: String, regStart: String, eventDate: String, regEnd: String, placesCount: Int, result: @escaping (Result<(Queue), NetworkError>) -> Void) {
		queueProvider.request(.createQueue(name: name, description: description, queueType: queueType, regStart: regStart, eventDate: eventDate, regEnd: regEnd, placesCount: placesCount)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(Queue.self) else {
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
	
	func updateQueue(id: Int, name: String?, description: String?, eventDate: String?, result: @escaping (Result<(Queue), NetworkError>) -> Void) {
		queueProvider.request(.updateQueue(id: id, name: name, description: description, eventDate: eventDate)) { (answer) in
			switch answer {
			case .success(let response):
				guard let answer = try? response.map(Queue.self) else {
					return result(.failure(.invalidResponse))
				}
				return result(.success(answer))
			case .failure(let error):
				switch error.response?.statusCode {
				case 400:
					return result(.failure(.invalidRequest))
				case 401, 403:
					return result(.failure(.invalidCredentials))
				case 404:
					return result(.failure(.notFound))
				default:
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func deleteQueue(queueId: Int, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		queueProvider.request(.delete(queueId: queueId)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
			case .failure(let error):
				switch error.response?.statusCode {
				case 400:
					return result(.failure(.invalidRequest))
				case 401, 403:
					return result(.failure(.invalidCredentials))
				case 404:
					return result(.failure(.notFound))
				default:
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func takePlace(queueId: Int, place: Int, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		queueProvider.request(.takeQueueSite(site: place, queueId: queueId)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
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
	}
	
	func freePlace(queueId: Int, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		queueProvider.request(.freeUpQueueSite(queueId: queueId)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
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
	}
	
	func takeFirstPlace(queueId: Int, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		queueProvider.request(.takeFirstQueueSite(queueId: queueId)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
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
	}
	
	func subscribeOnQueue(queueId: Int, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		queueProvider.request(.subscribeToQueue(queueId: queueId)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
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
	}
	
	func unsubscribeFromQueue(queueId: Int, result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		queueProvider.request(.unsubscribeFromQueue(queueId: queueId)) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
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
	}
	
}
