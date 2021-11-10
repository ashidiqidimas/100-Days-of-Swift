//
//  ViewController.swift
//  Project4
//
//  Created by Dimas on 12/08/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
	
	var webView: WKWebView!
	var progressView: UIProgressView!
	var selected: Int!
	
	var allowedWebsites = ["apple.com", "hackingwithswift.com"]
	var websites = ["apple.com", "hackingwithswift.com", "facebook.com"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = false
		
		webView = WKWebView()
		webView.navigationDelegate = self

		progressView = UIProgressView(progressViewStyle: .bar)
		
		progressView.translatesAutoresizingMaskIntoConstraints = false
		webView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(webView)
		webView.addSubview(progressView)
		addConstraint()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain,
																 target: self, action: #selector(openTapped))
		
		let url = URL(string: "https://" + websites[selected])!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		
		customizeToolbar()
		
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isToolbarHidden = true
	}
	
	func addConstraint() {
		let constraints = [
			webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			progressView.heightAnchor.constraint(equalToConstant: 5),
			progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			progressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		]
		
		NSLayoutConstraint.activate(constraints)
	}
	
	func customizeToolbar() {
		navigationController?.isToolbarHidden = false
		
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		let goBack = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action:
										#selector(goBackTapped))
		let goForward = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action:
											#selector(goForwardTapped))
		let btnSpacer = UIBarButtonItem(systemItem: .fixedSpace)
		btnSpacer.width = 10.0
		
//		progressView = UIProgressView(progressViewStyle: .default)
//		progressView.sizeToFit()
//		let progressButton = UIBarButtonItem(customView: progressView)
		toolbarItems = [goBack, btnSpacer, goForward, spacer, refresh]
	}
	
	@objc func goBackTapped() {
		webView.goBack()
	}
	
	@objc func goForwardTapped() {
		webView.goForward()
	}
	
	@objc func openTapped() {
		let actionSheet = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
		
		for website in websites {
			actionSheet.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
		}
		
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(actionSheet, animated: true)
	}
	
	@objc func openPage(action: UIAlertAction) {
		guard let actionTitle = action.title else { return }
		guard let url = URL(string: "https://" + actionTitle) else { return }
		webView.load(URLRequest(url: url))
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
			
			if progressView.progress == 1.0 {
				progressView.isHidden = true
			} else {
				progressView.isHidden = false
			}
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		self.title = webView.title
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		
		if let host = url?.host {
			for website in allowedWebsites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
			
			let alert = UIAlertController(title: "Can't open page",
										  message: "Sorry, you can't open that page because, well, it's facebook",
										  preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
			present(alert, animated: true)
		}
		
		decisionHandler(.cancel)
	}
	
}

