//
//  VKLoginViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/13/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController, WKNavigationDelegate {
	
	@IBOutlet weak var webkitView: WKWebView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "VK Login".localized
    navigationController?.isNavigationBarHidden = false
		webkitView.navigationDelegate = self
		activityIndicator.hidesWhenStopped = true
		activityIndicator.startAnimating()
		webkitView.load(URLRequest(url: URL(string: "https://queue-api.brakh.men/api/auth/vk?callback=brakhq://auth")!))
	}
	
}

extension VKLoginViewController {
	
	//    Called when web content begins to load in a web view.
	func webView(_ webView: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
		activityIndicator.startAnimating()
	}
	
	//Called when an error occurs during navigation.
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		activityIndicator.stopAnimating()
	}
	
	//    Called when an error occurs while the web view is loading content.
	func webView(_ webView:WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
		activityIndicator.stopAnimating()
	}
	
	//    Called when the navigation is complete.
	func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
		activityIndicator.stopAnimating()
	}
	
	
}
