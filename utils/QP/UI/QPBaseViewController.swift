//
//  QPBaseViewController.swift
//  QHProject
//
//  Created by quickplain on 15/12/24.
//  Copyright © 2015年 quickplain. All rights reserved.
//

import UIKit

//open typealias QPViewController = QPBaseViewController

open class QPViewController: UIViewController {

	public var info = NSDictionary()
	override open func viewDidLoad() {
		super.viewDidLoad()
	}

	/// 是否隐藏NavigationBar,默认不隐藏
	public var shouldHideNavigationBar: Bool = false

	override open func viewWillAppear(_ animated: Bool) {

		if shouldHideNavigationBar {

			self.navigationController?.setNavigationBarHidden(true, animated: animated)
		} else {
//  			self.navigationController?.navigationBar.translucent = false
//
//			self.navigationController?.setNavigationBarHidden(false, animated: animated)
 		}
		super.viewWillAppear(animated)
	}

	override open func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    open override func request() {
        super.request()
    }
    
    open override func requestMore() {
        super.requestMore()
    }
}

public extension UIViewController {
	/**
	 请求服务器方法.
	 */
	public func request() {
	}

	/**
	 请求加载更多
	 */
	public func requestMore() {
	}
}

public extension UIViewController {
	public func presentViewControllerFromKeyWindow() {
//        let vc = CJWWebViewController()
//        vc.url = "http://www.qq.com"
		let vc = self
		let barButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: vc, action: #selector(UIViewController.dismissVC))
		vc.navigationItem.leftBarButtonItem = barButton
		let navi = UINavigationController(rootViewController: vc)

		UIApplication.shared.keyWindow?.rootViewController?.present(navi, animated: true, completion: { () -> Void in
			//
		})
	}
}

public extension UIViewController {
	public func dismissVC() {
		self.dismiss(animated: true) {
			//
		}
	}
}

extension UIViewController {
	/**
	 安全的push view controller

	 - parameter viewController: 要跳转的view controller
	 - parameter animated:       是否动画 默认true
	 */
	open func pushViewController(viewController: UIViewController, animated: Bool = true) {
		if let navi = self.navigationController {
			if let vc = viewController as? QPTableViewController {
				vc.pushedViewController = self
			}
			viewController.hidesBottomBarWhenPushed = QPUtils.sharedInstance.config.hidesBottomBarWhenPushed
			navi.pushViewController(viewController, animated: animated)
 		}
	}
    
    open func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        pushViewController(viewController: viewController, animated: animated)
    }

	/**
	 安全的返回上一页

	 - parameter animated: 是否动画 默认true
	 */
	open func popVC(animated: Bool = true) {
		if let navi = self.navigationController {
            navi.popViewController(animated: animated)
		}
	}
    
    

	 

	/**
     测试,失败了
     重写navigationShouldPopOnBackButton这个方法实现吧少年
     - parameter action:
     */
	func setBackAction(action: Selector) {
		let back = UIBarButtonItem()
		// back.title = title
		back.action = action
		self.navigationItem.backBarButtonItem = back
	}

	open func showNetworkException() {
		let text = "网络错误"
		self.view.hideAllHUD()
		if view is UITableView {
			self.navigationController?.view.showHUDTemporary(text: text)
		} else {
			self.view.showHUDTemporary(text: text)
		}
		if let vc = self as? UITableViewController {
			vc.tableView.endRefreshing()
//            assertionFailure()
		}
	}
}

extension UIViewController {
	func newViewWillAppear(animated: Bool) {
//        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
		// IQKeyboardManager.sharedManager().enableAutoToolbar = false
//        IQKeyboardManager.sharedManager().preventShowingBottomBlankSpace = true
		// self.navigationController?.interactivePopGestureRecognizer?.delegate = self
		self.navigationItem.backBarButtonItem?.isEnabled = false
	}

	func newViewWillDisappear(animated: Bool) {
		self.view.endEditing(true)
		self.navigationController?.view.endEditing(true)
	}
}

public extension UIView {
	/**
	 把view以及子view的translatesAutoresizingMaskIntoConstraints = false
	 */
	public func setToAutoLayout() {
		if self.subviews.count > 0 {
			for sv in self.subviews {
				sv.setToAutoLayout()
			}
		}
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}

public extension UIViewController {
	public func pushViewControllerAndDismiss(vc: UIViewController) {
		if let navi = self.navigationController {
			vc.hidesBottomBarWhenPushed = QPUtils.sharedInstance.config.hidesBottomBarWhenPushed
			var vcs = navi.viewControllers
			vcs.removeLast()
			vcs.append(vc)
			navi.setViewControllers(vcs, animated: true)

		}
	}
}

extension UIViewController {
    
	open func addRightButton(title: String, action: Selector) {
		let barButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: action)
		self.navigationItem.rightBarButtonItem = barButton
	}

	open func addRightButton(title: String) {
		self.addRightButton(title: title, action: #selector(UIViewController.onClickRightButton))
	}

	open func onClickRightButton() {
        
	}
}

public extension UIViewController {
	public func translucentBar(color: UIColor) {
//        assertionFailure()
		self.navigationController?.navigationBar.translucentBar(color)
		self.navigationController?.navigationBar.isTranslucent = false
	}

	public func removeTranslucent() {
		self.navigationController?.navigationBar.isTranslucent = true
	}
}

extension UIViewController {
	func fuckingBack() {
		self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: Selector("back"))
	}

	func fuckingBackAgain() {
		self.navigationController?.interactivePopGestureRecognizer?.removeTarget(self, action: Selector("back"))
	}
}
