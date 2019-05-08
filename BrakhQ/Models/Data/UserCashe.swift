//
//  UserCashe.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

open class UserCashe: NSObject, NSCoding {
	
	open var id: Int
	open var name: String
	open var avatar: String? = nil
	
	init(user: User) {
		id = user.id
		name = user.name
		avatar = user.avatar
	}
	
	public required init?(coder aDecoder: NSCoder) {
		self.id = aDecoder.decodeInteger(forKey: "id")
		self.name = aDecoder.decodeObject(forKey: "name") as! String
		self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String
	}
	
	open func encode(with aCoder: NSCoder) {
		aCoder.encode(self.id, forKey: "id")
		aCoder.encode(self.name, forKey: "name")
		aCoder.encode(self.avatar, forKey: "avatar")
	}
}
