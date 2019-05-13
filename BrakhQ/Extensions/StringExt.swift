//
//  StringExt.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/12/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

extension String {
	
	func parse<D>(to type: D.Type) -> D? where D: Decodable {
		
		let data: Data = self.data(using: .utf8)!
		
		let decoder = JSONDecoder()
		
		do {
			let _object = try decoder.decode(type, from: data)
			return _object
			
		} catch {
			return nil
		}
	}
}

extension String {
	
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
}
