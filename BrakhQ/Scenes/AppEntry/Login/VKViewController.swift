//
//  VKLoginViewController.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/13/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import WebKit

class VkontakteLoginViewController: UIViewController, WKNavigationDelegate {
	
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
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		
		if webView != self.webkitView {
			decisionHandler(.allow)
			return
		}
		
		let app = UIApplication.shared
		if let url = navigationAction.request.url {
			// Handle target="_blank"
			if navigationAction.targetFrame == nil {
				if app.canOpenURL(url) {
					app.open(url)
					decisionHandler(.cancel)
					return
				}
			}
			
			// Handle phone and email links
			if url.scheme == "brakhq"  {
				if app.canOpenURL(url) {
					app.open(url)
				}
				
				decisionHandler(.cancel)
				return
			}
			
			decisionHandler(.allow)
		}
		
	}
	
	
}
