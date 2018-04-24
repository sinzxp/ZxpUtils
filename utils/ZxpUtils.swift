//
//  ZxpUtils.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/3.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZxpUtils: NSObject {

}

var ZSCREEN_HEIGHT =  UIScreen.main.bounds.size.height
var ZSCREEN_WIDTH =  UIScreen.main.bounds.size.width

//MARK: - 点击事件
public extension UIView {
    
    ///单击
    public func addTapViewGesture(_ target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    ///去除点击事件
    public func removeViewGesture() {
        self.isUserInteractionEnabled = false
    }
    
    ///双击
    public func addTapDoubleGesture(target: Any?, tapSingleDid: Selector?,tapDoubleDid: Selector?) {
        //单击监听
        let tapSingle = UITapGestureRecognizer(target:self, action: tapSingleDid)
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        //双击监听
        let tapDouble = UITapGestureRecognizer(target:self, action: tapDoubleDid)
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        //声明点击事件需要双击事件检测失败后才会执行
        tapSingle.require(toFail: tapDouble)
        self.addGestureRecognizer(tapSingle)
        self.addGestureRecognizer(tapDouble)
    }
   
    
}

//extension UIViewController:UIGestureRecognizerDelegate {
//
//    //重写侧滑
//    func handleNavigationTransition() {
//        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
//        let pan = UIPanGestureRecognizer(target:target, action:Selector(("handleNavigationTransition:")))
//        pan.delegate = self
//        self.view.addGestureRecognizer(pan)
//        //同时禁用系统原先的侧滑返回功能
//        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
//    }
//
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if self.childViewControllers.count == 1     //没有push的界面不会触发侧滑
//        {
//            return false
//        }
//        return true
//    }
//
//}

//for 循环倒叙
//
//for i in (0...10).reversed() {
//    print(i)
//}

//MARK: - 查找顶层控制器
public extension NSObject {
    
    // 找到当前显示的window
    public func getCurrentWindow() -> UIWindow? {
        // 找到当前显示的UIWindow
        var window: UIWindow? = UIApplication.shared.keyWindow
        /**
         window有一个属性：windowLevel
         当 windowLevel == UIWindowLevelNormal 的时候，表示这个window是当前屏幕正在显示的window
         */
        if window?.windowLevel != UIWindowLevelNormal {
            for tempWindow in UIApplication.shared.windows {
                if tempWindow.windowLevel == UIWindowLevelNormal {
                    window = tempWindow
                    break
                }
            }
        }
        return window
    }
    
    /// 获取顶层控制器 根据window
    public func atTheTopViewController() -> UIViewController? {
        let win = getCurrentWindow()
        return self.getTopVC(withCurrentVC: win?.rootViewController)
    }
    
    ///根据控制器获取 顶层控制器
    public func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
        
        if VC == nil {
            print("找不到顶层控制器")
            return nil
        }
        
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器 模态
            return getTopVC(withCurrentVC: presentVC)
        } else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器 选中的
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav 可见的
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        } else {
            // 返回顶控制器
            return VC
        }
    }
}

//MARK: - 查找View的控制器
public extension UIView {
    
    func viewController() -> UIViewController? {
        var view:UIView? = self
        while let responder = view?.next, view != nil {
            if responder.isKind(of: UIViewController.self){
                return responder as? UIViewController
            }
            view = view?.superview
        }
        return nil
    }
    
}

//MARK: - GCD的延时执行
public extension NSObject {
    public func delayPerform(_ time:DispatchTime,_ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
}

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

//MARK: - 返回随机颜色
extension UIColor {
    ///返回随机颜色
    open class var randomColor:UIColor{
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

//MARK: - 全屏截图
public extension NSObject {
    ///全屏截图
    func screenShot(_ save: Bool) -> UIImage? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if save {
//            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
        return image
    }
}

//MARK: - view截图
extension UIView {
    ///截取view的图片
    func viewShot() -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

