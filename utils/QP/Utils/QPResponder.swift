//
//  QPResponder.swift
//  CJWUtilsS
//
//  Created by Frank on 11/03/2017.
//  Copyright © 2017 cen. All rights reserved.
//

import UIKit

/// QP全局启动
open class QPResponder: UIResponder, UIApplicationDelegate {

	public var window: UIWindow?
	public var isNewFeature = false

    static let sharedInstance = QPResponder()

    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = QPWelcomViewController()
        window.makeKeyAndVisible()
        
        UINavigationBar.appearance().barStyle = UIBarStyle.black// 这是白色....
        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().barTintColor = UIColor.clear
        let bar = UINavigationBar.appearance()
        //		bar.translucentBar(UIColor.mainColor())
        bar.isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.mainColor()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        checkForceUpdate()
        NotificationCenter.default.addObserver(self, selector: #selector(QPResponder.onLogout), name: NSNotification.Name(rawValue: "onLogout"), object: nil)
        //		NotificationCenter.default.addObserver(self, selector: #selector(QPResponder.onLogin(_:)), name: "onLogin", object: nil)
        //        NotificationCenter.default.addObserver(self, selector: Selector("onLogin:"), name: NSNotification.Name(rawValue: "onLogin"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: Selector(("onLogin:")), name: NSNotification.Name(rawValue: "onLogin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(QPResponder.onLogin), name: NSNotification.Name(rawValue: "onLogin"), object: nil)
        /**
         *  是新装或者更新软件,不处理
         */
        if !isNewFeature {
            setupLoginStatus()
        }
        //		log.outputLogLevel = .Debug
        return true
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        let _ = onAutoLogin()
    }
 

	/**
     处理登录状态请求
     */
	open func setupLoginStatus() {
		if onAutoLogin() {
            print("onAutoLogin")
		} else {
			showLogin()
		}
	}

	/**
     检查更新
     */
	open func checkForceUpdate() {
		QPVersionUtils.isForceUpdate()
		QPVersionUtils.setup()

	}

	/**
     随意弹出页面
     
     - parameter viewController:
     */
	open func showVC(viewController: UIViewController) {
		window?.rootViewController = viewController
		window?.makeKeyAndVisible()
	}

	open class func showVC(viewController: UIViewController) {
		QPResponder.sharedInstance.showVC(viewController: viewController)
	}

	open func showNaviVC(vc: UIViewController) {
		let navi = UINavigationController(rootViewController: vc)
		self.showVC(viewController: navi)
	}

	/**
     登录成功通知
     
     - parameter notification:
     */
	open func onLogin() {
        print("onLogin")
	}

	/**
     跳转到登出
     */
	open func onLogout() {
	}

	/**
     跳转到登录页面
     */
	open func showLogin() {
	}

	/**
     处理自动登录,被动调用
     
     - returns: 是否正在进行自动登录
     */
	open func onAutoLogin() -> Bool {
		return false
	}
}
