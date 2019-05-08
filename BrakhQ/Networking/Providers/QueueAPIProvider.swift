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
	case updateQueue(id: Int, description: String?, regStart: String?, eventDate: String?, regEnd: String?, placesCount: Int?)
	case takeQueueSite(site: Int, queueId: Int)
	case freeUpQueueSite(queueId: Int)
	case takeFirstQueueSite(queueId: Int)
}

extension QueueAPIProvider: TargetType {
	var baseURL: URL {
		return URL(string: "http://queue2.brakh.men")!
	}
	
	var path: String {
		switch self {
		case .getQueue:
			return "/api/queue"
		case .createQueue:
			return "/api/queue"
		case .updateQueue:
			return "/api/queue"
		case .takeQueueSite(_, let queueId):
			return "/api/queues/\(queueId)/places"
		case .freeUpQueueSite(let queueId):
			return "/api/queues/\(queueId)/places"
		case .takeFirstQueueSite(let queueId):
			return "/api/queues/\(queueId)/places/first"
		}
	}
	
	var method: Method {
		switch self {
		case .getQueue:
			return .get
		case .createQueue, .takeQueueSite, .takeFirstQueueSite:
			return .post
		case .updateQueue, .freeUpQueueSite:
			return .put
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
		case .updateQueue(let id, let description, let regStart, let eventDate, let regEnd, let placesCount):
			var params: [String:Any] = ["id": id]
			if let desript = description {
				params["description"] = desript
			}
			if let start = regStart {
				params["reg_start"] = start
			}
			if let event = eventDate {
				params["event_date"] = event
			}
			if let end = regEnd {
				params["reg_end"] = end
			}
			if let places = placesCount {
				params["places_count"] = places
			}
			return .requestParameters(
				parameters: params,
				encoding: JSONEncoding.default
			)
		case .takeQueueSite(let site, _):
			return .requestParameters(
				parameters: [
					"place": site
				],
				encoding: URLEncoding.default
			)
		case .freeUpQueueSite(_):
			return .requestPlain
		case .takeFirstQueueSite(_):
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		switch self {
		case .getQueue:
			return nil
		case .takeQueueSite, .freeUpQueueSite, .takeFirstQueueSite:
			return ["Authorization": AuthManager.shared.token ?? ""]
		case .createQueue, .updateQueue:
			return ["Authorization": AuthManager.shared.token ?? "",
							"Content-Type": "application/json"]
		}
		
		
	}
	
	var validationType: ValidationType {
		return .successCodes
	}
	
}
