//
//  YGWebViewController.swift
//  YGProject
//
//  Created by Frank on 12/18/15.
//  Copyright © 2015 YG. All rights reserved.
//

import UIKit

/// 简易web controller
open class QPWebViewController: QPViewController, UIWebViewDelegate {

	open let webView = UIWebView()

	public var url: String? = ""
	public var html: String?

	public var isPresent = false

	public var isShowLeftButtons = true

	public var isLoadTitle = true

	public func agent() -> String {
		return ""
	}

	private func setupAgent() {
		let agentString = agent()
		let oldAgent = self.webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
		if let newAgent = oldAgent?.appending(" \(agentString)") {
			let dict = ["UserAgent": newAgent]
			UserDefaults.standard.register(defaults: dict)
		}
	}

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	override open func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(webView)
		setupAgent()
		webView.alignTop("0", leading: "0", bottom: "0", trailing: "0", toView: self.view)
		webView.delegate = self

		if !load(url: url) {

			loadHtml(html)
		}

		self.view.setNeedsUpdateConstraints()
		self.view.updateConstraintsIfNeeded()
        
	}

	/**
	 加载html字符
	 (self.webView.scalesPageToFit = true)

	 - parameter html: html字符
	 */
	open func loadHtml(_ html: String?) {
		self.webView.scalesPageToFit = true
		if let hhh = html {
			if hhh.valid() {
				self.html = html
				self.webView.loadHTMLString(hhh, baseURL: nil)
			}
		}
	}

	/**
	 加载url

	 - parameter url: 需要加载的url

	 - returns: 是否加载成功
	 */
	open func load(url: String?) -> Bool {
		if url != nil && url != "" {
			self.url = url!
			if let nsurl = NSURL(string: url!) {
				let request = NSURLRequest(url: nsurl as URL)
				webView.loadRequest(request as URLRequest)
				return true
			} else {
			}
		}
		return false
	}
    
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        if isLoadTitle {
            self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        }
        if webView.canGoBack {
            showBackAndClose()
        } else {
            showClose()
        }

    }

//	open func webViewDidFinishLoad(webView: UIWebView) {
//		if isLoadTitle {
//			self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
//		}
//		if webView.canGoBack {
//			showBackAndClose()
//		} else {
//			showClose()
//		}
//	}
    
    open func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }

//	open func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//		return true
//	}

	open func currentURL() -> String? {
//		return (self.webView.request?.URLRequest.URL?.absoluteString)
        return self.webView.request?.urlRequest?.url?.absoluteString
	}

	open func back() {
		self.webView.goBack()
	}

	open func close() {
		if isPresent {
			self.dismissVC()
		} else {
			self.popVC()
		}
	}

	open func showClose() {

		if isShowLeftButtons {
			let closeButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QPWebViewController.close))
			self.navigationItem.leftBarButtonItems = [closeButton]
		}

	}

	private func showBackAndClose() {

		if isShowLeftButtons {
			let btn = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QPWebViewController.back))

			let closeButton = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QPWebViewController.close))

			self.navigationItem.leftBarButtonItems = [btn, closeButton]
		}

	}

}
