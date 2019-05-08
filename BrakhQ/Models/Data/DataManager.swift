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
	
	func addNewQueue(_ queue: Queue) {
		let feed = (DataCache.instance.readObject(forKey: FeedKeys.feed.rawValue) as? FeedCashe) ?? FeedCashe(queues: [])
		feed.queues.append(QueueCashe(queue: queue))
		DataCache.instance.write(object: feed, forKey: FeedKeys.feed.rawValue)
	}
	
}
