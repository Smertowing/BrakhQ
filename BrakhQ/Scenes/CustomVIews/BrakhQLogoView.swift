//
//  BrakhQLogoView.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/5/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class BrakhQLogoView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		let imageView = UIImageView(image: UIImage(named: "BQLabel"))
		imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)
		imageView.autoresizingMask = .flexibleWidth
		self.frame = CGRect(x: 0, y: 0, width: 120, height: 140)
		imageView.contentMode = .scaleAspectFit
		imageView.center = CGPoint(x: 60, y: 70)
		addSubview(imageView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
