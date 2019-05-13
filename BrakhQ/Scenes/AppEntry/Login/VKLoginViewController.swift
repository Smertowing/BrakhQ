//
//  VKLoginViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/13/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class VKLoginViewController: UIViewController, UIWebViewDelegate {
	
	@IBOutlet weak var webkitView: UIWebView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "VK Login".localized
    navigationController?.isNavigationBarHidden = false
		webkitView.delegate = self
		activityIndicator.hidesWhenStopped = true
		activityIndicator.startAnimating()
		webkitView.loadRequest(URLRequest(url: URL(string: "https://queue-api.brakh.men/api/auth/vk?callback=brakhq://auth")!))
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		activityIndicator.stopAnimating()
	}
	
}
