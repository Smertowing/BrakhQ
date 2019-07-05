//
//  QueueCashe.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

open class QueueCashe: NSObject, NSCoding {
	open var busyPlaces: [PlaceCashe]
	open var descript: String?
	open var eventDate: Date
	open var id: Int
	open var name: String
	open var owner: UserCashe
	open var placesCount: Int
	open var queueType: QueueType
	open var regActive: Bool
	open var regEnded: Bool
	open var regStarted: Bool
	open var regEndDate: Date
	open var regStartDate: Date
	open var url: String
	
	init(queue: Queue) {
		busyPlaces = []
		for place in queue.busy_places {
			busyPlaces.append(PlaceCashe(place: place))
		}
		descript = queue.description
		eventDate = Date(dateString: queue.event_date, format: Date.iso8601Format, timeZone: .autoupdatingCurrent)
		id = queue.id
		name = queue.name
		owner = UserCashe(user: queue.owner)
		placesCount = queue.places_count
		queueType = queue.queue_type
		regActive = queue.regActive
		regEnded = queue.regEnded
		regStarted = queue.regStarted
		regEndDate = Date(dateString: queue.reg_end, format: Date.iso8601Format, timeZone: .autoupdatingCurrent)
		regStartDate = Date(dateString: queue.reg_start, format: Date.iso8601Format, timeZone: .autoupdatingCurrent)
		url = queue.url
	}
	
	func remove(_ place: Place) {
		for i in 0..<busyPlaces.count {
			if busyPlaces[i].place == place.place {
				busyPlaces.remove(at: i)
				return
			}
		}
	}
	
	func add(_ place: Place) {
		busyPlaces.append(PlaceCashe(place: place))
	}
	
	public required init?(coder aDecoder: NSCoder) {
		self.busyPlaces = aDecoder.decodeObject(forKey: "busyPlaces") as! [PlaceCashe]
		self.descript = aDecoder.decodeObject(forKey: "description") as? String
		self.eventDate = aDecoder.decodeObject(forKey: "eventDate") as! Date
		self.id = aDecoder.decodeInteger(forKey: "id")
		self.name = aDecoder.decodeObject(forKey: "name") as! String
		self.owner = aDecoder.decodeObject(forKey: "owner") as! UserCashe
		self.placesCount = aDecoder.decodeInteger(forKey: "placesCount")
		self.queueType = QueueType(rawValue: aDecoder.decodeObject(forKey: "queueType") as! String)!
		self.regActive = aDecoder.decodeBool(forKey: "regActive")
		self.regEnded = aDecoder.decodeBool(forKey: "regEnded")
		self.regStarted = aDecoder.decodeBool(forKey: "regStarted")
		self.regEndDate = aDecoder.decodeObject(forKey: "regEndDate") as! Date
		self.regStartDate = aDecoder.decodeObject(forKey: "regStartDate") as! Date
		self.url = aDecoder.decodeObject(forKey: "url") as! String
	}
	
	open func encode(with aCoder: NSCoder) {
		aCoder.encode(self.busyPlaces, forKey: "busyPlaces")
		aCoder.encode(self.descript, forKey: "description")
		aCoder.encode(self.eventDate, forKey: "eventDate")
		aCoder.encode(self.id, forKey: "id")
		aCoder.encode(self.name, forKey: "name")
		aCoder.encode(self.owner, forKey: "owner")
		aCoder.encode(self.placesCount, forKey: "placesCount")
		aCoder.encode(self.queueType.rawValue, forKey: "queueType")
		aCoder.encode(self.regActive, forKey: "regActive")
		aCoder.encode(self.regEnded, forKey: "regEnded")
		aCoder.encode(self.regStarted, forKey: "regStarted")
		aCoder.encode(self.regEndDate, forKey: "regEndDate")
		aCoder.encode(self.regStartDate, forKey: "regStartDate")
		aCoder.encode(self.url, forKey: "url")
	}
}
