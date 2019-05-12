//
//  PlaceCashe.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

open class PlaceCashe: NSObject, NSCoding {
	open var place: Int
	open var user: UserCashe?
	
	init(place: Place) {
		self.place = place.place
		user = UserCashe(user: place.user)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		self.place = aDecoder.decodeInteger(forKey: "place")
		self.user = aDecoder.decodeObject(forKey: "user") as? UserCashe
	}
	
	open func encode(with aCoder: NSCoder) {
		aCoder.encode(self.place, forKey: "place")
		aCoder.encode(self.user, forKey: "user")
	}
}

