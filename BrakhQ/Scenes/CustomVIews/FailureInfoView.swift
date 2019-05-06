//
//  FailureInfoView.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit


class FailureInfoView: UIViewController {
	
	@IBOutlet weak var alertView: UIView!
	@IBOutlet weak var okeyButton: UIButton!
	@IBOutlet weak var descriptionTextView: UITextView!
	
	
	var errors: [String : String]?
	
	let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.becomeFirstResponder()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
		animateView()
		setupLabels()
	}
	
	func setupView() {
		alertView.layer.cornerRadius = 15
		self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
	}
	
	func animateView() {
		alertView.alpha = 0;
		self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
		UIView.animate(withDuration: 0.4, animations: { () -> Void in
			self.alertView.alpha = 1.0;
			self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
		})
	}
	
	func setupLabels() {
		
		var descriptionText: String = ""
		if let errorsDictionary = errors {
			for keyValue in errorsDictionary {
				descriptionText.append("\(keyValue.key):")
				descriptionText.append("\n")
				descriptionText.append("\(keyValue.value)")
				descriptionText.append("\n\n")
			}
		}
		descriptionTextView.text = descriptionText
		
	}
	
	@IBAction func onTapCancelButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
}
