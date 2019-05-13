//
//  FeedCashe.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

open class FeedCashe: NSObject, NSCoding {
	
	open var queues: [QueueCashe]
	
	init(queues: [Queue]) {
		self.queues = []
		for queue in queues {
			self.queues.append(QueueCashe(queue: queue))
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		self.queues = aDecoder.decodeObject(forKey: "queues") as! [QueueCashe]
	}
	
	open func encode(with aCoder: NSCoder) {
		aCoder.encode(self.queues, forKey: "queues")
	}
}
