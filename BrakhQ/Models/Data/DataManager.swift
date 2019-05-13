//
//  DataManager.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import DataCache

final class DataManager {
	static let shared = DataManager()

	private init() {}
	
	var usedFeed: FeedCashe {
		get {
			return (DataCache.instance.readObject(forKey: FeedKeys.usedFeed.rawValue) as? FeedCashe) ?? FeedCashe(queues: [])
		}
		set {
			DataCache.instance.clean(byKey: FeedKeys.usedFeed.rawValue)
			DataCache.instance.write(object: newValue, forKey: FeedKeys.usedFeed.rawValue)
		}
	}
	
	var createdFeed: FeedCashe {
		get {
			return (DataCache.instance.readObject(forKey: FeedKeys.createdFeed.rawValue) as? FeedCashe) ?? FeedCashe(queues: [])
		}
		set {
			DataCache.instance.clean(byKey: FeedKeys.createdFeed.rawValue)
			DataCache.instance.write(object: newValue, forKey: FeedKeys.createdFeed.rawValue)
		}
	}
	
	func logout() {
		DataCache.instance.cleanAll()
	}
	
	func addNew(_ queue: Queue, to feedType: FeedKeys, completionHandler: @escaping ()->Void) {
		let feed = (DataCache.instance.readObject(forKey: feedType.rawValue) as? FeedCashe) ?? FeedCashe(queues: [])
		var isNew = true
		let updatedQueues = feed.queues.map { (prevQueue) -> QueueCashe in
			if prevQueue.id == queue.id {
				isNew = false
				return QueueCashe(queue: queue)
			} else {
				return prevQueue
			}
		}
		feed.queues = updatedQueues
		if isNew {
			feed.queues.append(QueueCashe(queue: queue))
		}
		DataCache.instance.write(object: feed, forKey: feedType.rawValue)
		completionHandler()
	}
	
}
