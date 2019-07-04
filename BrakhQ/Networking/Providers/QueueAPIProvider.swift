//
//  QueueAPIProvider.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Moya

enum QueueAPIProvider {
	case getQueue(url: String)
	case createQueue(name: String, description: String?, queueType: String, regStart: String, eventDate: String, regEnd: String, placesCount: Int)
	case updateQueue(id: Int, name: String?, description: String?, eventDate: String?)
	case delete(queueId: Int)
	case takeQueueSite(site: Int, queueId: Int)
	case freeUpQueueSite(queueId: Int)
	case takeFirstQueueSite(queueId: Int)
	case subscribeToQueue(queueId: Int)
	case unsubscribeFromQueue(queueId: Int)
}

extension QueueAPIProvider: TargetType {
	var baseURL: URL {
		return URL(string: "https://queue-api.brakh.men/api/v2")!
	}
	
	var path: String {
		switch self {
		case .getQueue:
			return "/queue"
		case .createQueue:
			return "/queue"
		case .updateQueue:
			return "/queue"
		case .delete:
			return "/queue"
		case .takeQueueSite(_, let queueId):
			return "/queues/\(queueId)/places"
		case .freeUpQueueSite(let queueId):
			return "/queues/\(queueId)/places"
		case .takeFirstQueueSite(let queueId):
			return "/queues/\(queueId)/places/first"
		case .subscribeToQueue(let queueId):
			return "/queues/\(queueId)/subscription"
		case .unsubscribeFromQueue(let queueId):
			return "/queues/\(queueId)/subscription"
		}
	}
	
	var method: Method {
		switch self {
		case .getQueue:
			return .get
		case .createQueue, .takeQueueSite, .takeFirstQueueSite, .subscribeToQueue:
			return .post
		case .updateQueue:
			return .put
		case .delete, .unsubscribeFromQueue, .freeUpQueueSite:
			return .delete
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		switch self {
		case .getQueue(let url):
			return .requestParameters(
				parameters: [
					"url": url
				],
				encoding: URLEncoding.default
			)
		case .createQueue(let name, let description, let queueType, let regStart, let eventDate, let regEnd, let placesCount):
			var params: [String:Any] = ["name": name,
																			"queue_type": queueType,
																			"reg_start": regStart,
																			"event_date": eventDate,
																			"reg_end": regEnd,
																			"places_count": placesCount]
			if let descript = description {
				params["description"] = descript
			}
			return .requestParameters(
				parameters: params,
				encoding: JSONEncoding.default
			)
		case .updateQueue(let id, let name, let description, let eventDate):
			var params: [String:Any] = ["id": id]
			if let name = name {
				params["name"] = name
			}
			if let desript = description {
				params["description"] = desript
			}
			if let event = eventDate {
				params["event_date"] = event
			}
			return .requestParameters(
				parameters: params,
				encoding: JSONEncoding.default
			)
		case .delete(let queueId):
			return .requestParameters(
				parameters: [
					"queueId": queueId
				],
				encoding: URLEncoding.default
			)
		case .takeQueueSite(let site, _):
			return .requestParameters(
				parameters: [
					"place": site
				],
				encoding: URLEncoding.default
			)
		case .freeUpQueueSite:
			return .requestPlain
		case .takeFirstQueueSite:
			return .requestPlain
		case .subscribeToQueue:
			return .requestPlain
		case .unsubscribeFromQueue:
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		switch self {
		case .getQueue:
			return nil
		case .takeQueueSite, .freeUpQueueSite, .delete, .takeFirstQueueSite, .subscribeToQueue, .unsubscribeFromQueue:
			return ["Authorization": AuthManager.shared.token ?? ""]
		case .createQueue, .updateQueue:
			return ["Authorization": AuthManager.shared.token ?? "",
							"Content-Type": "application/json"]
		}
		
		
	}
	
	var validationType: ValidationType {
		switch self {
		case .createQueue:
			return .customCodes([201])
		default:
			return .customCodes([200])
		}
	}
	
}
