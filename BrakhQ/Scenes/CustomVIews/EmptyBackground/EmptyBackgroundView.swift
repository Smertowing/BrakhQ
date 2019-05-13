//
//  EmptyBackgroundView.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/14/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class EmptyBackgroundView: UIView {
	
	class func instanceFromNib() -> UIView {
		return UINib(nibName: "EmptyBackgroundView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
	}

}
