//
//  DateExt.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

extension Date {
	
	static var iso8601Format = "yyyy-MM-dd HH:mm:ss.SSS Z"
	
	var iso8601: String {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = .autoupdatingCurrent
		dateFormatter.dateFormat = Date.iso8601Format
		
		return dateFormatter.string(from: self)
	}
	
	var displayDate: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		return dateFormatter.string(from: self)
	}
	
	var displayTime: String {
		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .short
		return dateFormatter.string(from: self)
	}
}
