//
//  UserItem.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class UserItem: Object {
	
	enum Property: String {
		case id, name, avatar
	}
	
	@objc dynamic var id = -1
	@objc dynamic var name = ""
	@objc dynamic var avatar = ""
	
	override static func primaryKey() -> String? {
		return UserItem.Property.id.rawValue
	}
	
	convenience init(_ user: User) {
		self.init()
		self.id = user.id
		self.name = user.name
		self.avatar = user.avatar
	}
}

extension UserItem {
	
	static func all(in realm: Realm = try! Realm()) -> Results<UserItem> {
		return realm.objects(UserItem.self)
			.sorted(byKeyPath: UserItem.Property.name.rawValue)
	}
	
	@discardableResult
	static func add(user: User, in realm: Realm = try! Realm())
		-> UserItem {
			let item = UserItem(user)
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

