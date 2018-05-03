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
        self.isUserInteractionEnabled = true
        //单击监听
        let tapSingle = UITapGestureRecognizer(target:target, action: tapSingleDid)
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        //双击监听
        let tapDouble = UITapGestureRecognizer(target:target, action: tapDoubleDid)
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        //声明点击事件需要双击事件检测失败后才会执行
        tapSingle.require(toFail: tapDouble)
        self.addGestureRecognizer(tapSingle)
        self.addGestureRecognizer(tapDouble)
    }
    
    ///长按
    public func addLongPressGesture(_ target: Any?, action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longPress)
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

//MARK: - GCD定时器倒计时
public extension NSObject {
    
//    timer.suspend() //定时器暂停执行
//    timer.cancel() //定时器取消，会销毁
//    timer.activate() //定时器开始激活
//    timer.resume() //定时器继续
    
    ///   - timeInterval: 循环间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
    public func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->()) {
        if repeatCount <= 0 {
            return
        }
        // 在global线程里创建一个时间源 在主线程中创建一个定时器
//        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        // 立即开始 设定这个时间间隔
        timer.scheduleRepeating(deadline: .now(), interval: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
    }
    
    ///   - timeInterval: 循环间隔时间
    ///   - handler: 循环事件
    public func DispatchTimer(timeInterval: Double, handler:@escaping (DispatchSourceTimer?)->()) {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.scheduleRepeating(deadline: .now(), interval: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                handler(timer)
            }
        }
        timer.resume()
    }
   
}

//MARK: - Timer定时器倒计时
public extension NSObject {
    
    ///  退出的时候清空定时器->timer.invalidate()
    func TimerPerform(timeInterval: Double) -> Timer {
        // 启用计时器，控制每秒执行一次tickDown方法
        let timer = Timer.scheduledTimer(timeInterval: timeInterval, target:self,selector:#selector(TimerPerformHandler), userInfo:nil,repeats:true)
        return timer
    }
    
    ///计时器每秒触发事件
    public func TimerPerformHandler() {
        
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
    func screenShot(_ save: Bool = false) -> UIImage? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image , save {
            savedPhoto(image)
        }
        return image
    }
}

//MARK: - view截图
extension UIView {
    ///截取view的图片
    func viewShot(_ save: Bool = false) -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image , save {
            savedPhoto(image)
        }
        return image
    }
}

//MARK: - ScrollView截图
extension UIScrollView {
    ///ScrollView截图
    func capture(_ save: Bool = false) ->  UIImage? {
        // 记录当前的scrollView的偏移量和坐标
        let currentContentOffSet:CGPoint = self.contentOffset
        let currentFrame:CGRect = self.frame
        // 设置为zero和相应的坐标
        self.contentOffset = CGPoint.zero
        self.frame = CGRect.init(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
        UIGraphicsBeginImageContextWithOptions(self.contentSize, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 重新设置原来的参数
        self.contentOffset = currentContentOffSet
        self.frame = currentFrame
        UIGraphicsEndImageContext()
        if let image = image , save {
            savedPhoto(image)
        }
        return image
    }
}

//MARK: - 从图片上截图一部分内容
extension UIImage {
    ///从图片上截图一部分内容
    func shearImage(_ rect:CGRect ) -> UIImage {
        let scale = UIScreen.main.scale // 获取当前屏幕坐标与像素坐标的比例
        let sourceImageRef: CGImage = self.cgImage!
        let newCGImage = sourceImageRef.cropping(to: CGRect(x: rect.minX * scale, y: rect.minY * scale, width: rect.width * scale, height: rect.height * scale ))
        let newImage = UIImage(cgImage: newCGImage!)
        print("---> \(rect)")
        return newImage
    }
}

//MARK: - url转码
extension String {
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    ///url
//    func encodeEscapesURL(_ value:String) -> String {
//        let str:NSString = value as NSString
//        let originalString = str as CFString
//        let charactersToBeEscaped = "!*'();:@&=+$,/?%#[]" as CFString  //":/?&=;+!@#$()',*"    //转意符号
//        //let charactersToLeaveUnescaped = "[]." as CFStringRef  //保留的符号
//        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                             originalString,
//                                                    nil,    //charactersToLeaveUnescaped,
//                charactersToBeEscaped,
//                CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue)) as NSString
//        return result as String
//    }
}

//MARK: - iphone X 的顶部和底部距离
extension NSObject {
    
    var safeAreaTopHeight:CGFloat {
        get {
            if isX {
                return 88
            } else {
                return 64
            }
        }
    }
    
    var safeAreabottomHeight:CGFloat {
        get {
            if isX {
                return 34
            } else {
                return 0
            }
        }
    }
    
    var isX:Bool {
        get {
            if ZSCREEN_HEIGHT == 812.0 && ZSCREEN_WIDTH == 375.0 {
                return true
            } else {
                return false
            }
        }
    }
}

//MARK: - UILabel根据最大宽度计算宽高
extension UILabel {
    ///根据最大宽度计算宽高
    func getLableSize(text: String , maxWidth: CGFloat) -> CGSize {
        let maxSize = CGSize(width: maxWidth, height: 0)   //注意高度是0
        let size = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin,attributes: [NSFontAttributeName:self.font], context: nil)
        return size.size
    }
    
}

//MARK: - 查询lable高度
extension String {
    /**
     * 查询lable高度
     * @param fontSize, 字体大小
     * @param width, lable宽度
     */
    func getLableHeightByWidth(_ fontSize: CGFloat, width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
}

