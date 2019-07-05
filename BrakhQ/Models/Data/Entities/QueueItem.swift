//
//  QueueItem.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class QueueItem: Object {
	
	enum Property: String {
		case busyPlaces, descript, eventDate, id, name, owner, placesCount, queueType, regActive, regEnded, regStarted, regEnd, regStart, url
	}
	
	@objc dynamic var busyPlaces: [PlaceItem] = []
	@objc dynamic var descript: String?
	@objc dynamic var eventDate: Date = Date.distantPast
	@objc dynamic var id: Int = -1
	@objc dynamic var name: String = ""
	@objc dynamic var owner: UserItem = UserItem()
	@objc dynamic var placesCount: Int = -1
	@objc dynamic var queueType: String = QueueType.def.rawValue
	@objc dynamic var regActive: Bool = false
	@objc dynamic var regEnded: Bool = false
	@objc dynamic var regStarted: Bool = false
	@objc dynamic var regEnd: Date = Date.distantPast
	@objc dynamic var regStart: Date = Date.distantPast
	@objc dynamic var url: String = ""
	
	override static func primaryKey() -> String? {
		return QueueItem.Property.id.rawValue
	}
	
	convenience init(_ queue: Queue) {
		self.init()
		for place in queue.busy_places {
			self.busyPlaces.append(PlaceItem(place))
		}
		self.descript = queue.description
		self.eventDate = Date(dateString: queue.event_date, format: Date.iso8601Format, timeZone: .autoupdatingCurrent)
		self.id = queue.id
		self.name = queue.name
		self.owner = UserItem(queue.owner)
		self.placesCount = queue.places_count
		self.queueType = queue.queue_type.rawValue
		self.regActive = queue.regActive
		self.regEnded = queue.regEnded
		self.regStarted = queue.regStarted
		self.regEnd = Date(dateString: queue.reg_end, format: Date.iso8601Format, timeZone: .autoupdatingCurrent)
		self.regStart = Date(dateString: queue.reg_start, format: Date.iso8601Format, timeZone: .autoupdatingCurrent)
		self.url = queue.url
	}
}

extension QueueItem {
	
	static func all(in realm: Realm = try! Realm()) -> Results<QueueItem> {
		return realm.objects(QueueItem.self)
			.sorted(byKeyPath: QueueItem.Property.id.rawValue)
	}
	
	@discardableResult
	static func add(queue: Queue, in realm: Realm = try! Realm())
		-> QueueItem {
			let item = QueueItem(queue)
			try! realm.write {
				realm.add(item)
			}
			return item
	}
	
	func delete() {
		guard let realm = realm else { return }
		try! realm.write {
			realm.delete(self)
		}
	}
	
}
