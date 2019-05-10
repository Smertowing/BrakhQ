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
	
	var feed: FeedCashe {
		get {
			return (DataCache.instance.readObject(forKey: FeedKeys.feed.rawValue) as? FeedCashe) ?? FeedCashe(queues: [])
		}
	}
	
	func logout() {
		DataCache.instance.cleanAll()
	}
	
	func addNewQueue(_ queue: Queue, completionHandler: @escaping ()->Void) {
		let feed = (DataCache.instance.readObject(forKey: FeedKeys.feed.rawValue) as? FeedCashe) ?? FeedCashe(queues: [])
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
		DataCache.instance.write(object: feed, forKey: FeedKeys.feed.rawValue)
		completionHandler()
	}
	
}
