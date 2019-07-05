//
//  PlaceItem.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class PlaceItem: Object {
	
	enum Property: String {
		case place, user
	}
	
	@objc dynamic var place = -1
	@objc dynamic var user: UserItem?
	
	override static func primaryKey() -> String? {
		return PlaceItem.Property.place.rawValue
	}
	
	convenience init(_ place: Place) {
		self.init()
		self.place = place.place
		self.user = UserItem(place.user)
	}
}
