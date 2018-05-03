//
//  ZXPToastView.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/2.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

extension NSObject {
    var Toast: ZXPToastView {
        return ZXPToastView.share
    }
}

///UIWindow Toast 弹窗
class ZXPToastView: NSObject {
    
    static let share = ZXPToastView()
    
    //显示位置
    enum Position: Int {
        case Top
        case Mid
        case Bottom
    }
    
    public var _window: UIWindow?

    public var windows: [UIWindow] = []  //缓存window
    
    /**
    - title 显示文字
    - delay 显示时长
    - position 位置
    - clickBgHidden 点击背景隐藏
    - autoHidden 自动隐藏
     **/
    public func showToast(_ title:String = "" ,delay:Double = 2.0 ,position:Position = .Mid,clickBgHidden:Bool = true, autoHidden:Bool = true) {

        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.frame = UIScreen.main.bounds
        
        let maxW: CGFloat = ZSCREEN_WIDTH * 0.8

        let lableView = UILabel()
        lableView.font = UIFont.systemFont(ofSize: 15)
        lableView.textColor = UIColor.white
        lableView.text = title
        lableView.textAlignment = .center
        lableView.numberOfLines = 0
        let lableViewSize = lableView.getLableSize(text: title, maxWidth: maxW)

        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor.lightGray
        container.addSubview(bgView)
        
        switch position {
        case .Top:
            bgView.frame.size = CGSize(width: lableViewSize.width + 20, height: lableViewSize.height + 20)
            bgView.center = container.center
            bgView.frame.origin.y = ZSCREEN_HEIGHT * 0.15
        case .Mid:
            bgView.frame.size = CGSize(width: lableViewSize.width + 20, height: lableViewSize.height + 20)
            bgView.center = container.center
        case .Bottom:
            bgView.frame.size = CGSize(width: lableViewSize.width + 20, height: lableViewSize.height + 20)
            bgView.center = container.center
            bgView.frame.origin.y = ZSCREEN_HEIGHT * 0.85 - (lableViewSize.height + 20) / 2
        }

        lableView.frame = CGRect(x: 10, y: 10 , width: lableViewSize.width, height: lableViewSize.height)
        bgView.addSubview(lableView)
        
        if clickBgHidden {
            container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:))))
        }
        
        show(container,delay: delay,autoHidden:autoHidden)
    }
    
    /**
     - 非莫的
     - title 显示文字
     - delay 显示时长
     - position 位置
     **/
    public func showToastExt(_ title:String = "" ,delay:Double = 2.0 ,position:Position = .Mid) {
        
        let maxW: CGFloat = ZSCREEN_WIDTH * 0.8

        let lableView = UILabel()
        lableView.font = UIFont.systemFont(ofSize: 15)
        lableView.textColor = UIColor.white
        lableView.text = title
        lableView.textAlignment = .center
        lableView.numberOfLines = 0
        let lableViewSize = lableView.getLableSize(text: title, maxWidth: maxW)
        
        var windowRect:CGRect!
        let MidX:CGFloat = ZSCREEN_WIDTH / 2 - (lableViewSize.width + 20) / 2
        switch position {
        case .Top:
            windowRect = CGRect (x: MidX, y: ZSCREEN_HEIGHT * 0.15, width: lableViewSize.width + 20, height: lableViewSize.height + 20)
        case .Mid:
            let MidH:CGFloat = ZSCREEN_HEIGHT / 2 - (lableViewSize.height + 20) / 2
            windowRect = CGRect (x: MidX, y: MidH, width: lableViewSize.width + 20, height: lableViewSize.height + 20)
        case .Bottom:
            windowRect = CGRect (x: MidX, y: ZSCREEN_HEIGHT * 0.85, width: lableViewSize.width + 20, height: lableViewSize.height + 20)
        }
        
        lableView.frame = CGRect(x: 10, y: 10 , width: lableViewSize.width, height: lableViewSize.height)

        show(lableView, bgColor: UIColor.lightGray, frame: windowRect, radius: 10,delay: delay)
        
    }
    
    /**
     - view 显示的view
     - bgColor window背景颜色
     - frame window位置大小
     - radius 圆角
     - delay 显示时长
     - autoHidden 自动隐藏
     **/
    public func show(_ view:UIView,bgColor:UIColor = UIColor.clear,frame:CGRect = UIScreen.main.bounds,radius:CGFloat = 0,delay:Double = 2.0,autoHidden:Bool = true){
        let window = UIWindow() ///不用添加到其他地方就能显示
        window.frame = frame
        window.backgroundColor = bgColor
        window.windowLevel = UIWindowLevelAlert ///显示等级
        window.isHidden = false
        window.layer.cornerRadius = radius
        window.addSubview(view)
        self.windows.append(window)
        if autoHidden {
            self.perform(#selector(showShutDown(sender:)), with: window, afterDelay: delay)
        }
    }
    
    //添加点击事件 隐藏
    public func tapGesture(sender: UITapGestureRecognizer) {
        if let window = sender.view?.superview as? UIWindow {
            if let index = windows.index(of: window) {
                ///清除延时执行
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showShutDown(sender:)), object: window)
                windows.remove(at: index)  //删除
            }
        }
    }
    
    //toast超时关闭
    public func showShutDown(sender: AnyObject) {
        if let window = sender as? UIWindow {
            if let index = windows.index(of: window) {
                windows.remove(at: index)  //删除
            }
        } else {
            //do nothing
        }
    }
    
    //关闭所有
    public func showShutDownAll() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        windows.removeAll()
    }

}

extension ZXPToastView {
    
     /// - 加载转圈圈 只显示最后一个
     /// - title 显示文字
     /// - clickBgHidden 点击背景隐藏
    public func showLoadingText(_ title:String = "",clickBgHidden:Bool = false) {
        
        stopLoading()
        
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.frame = UIScreen.main.bounds
        
        let bgLength: CGFloat = 90.0
        let bgView = UIView()
        bgView.frame.size = CGSize(width: bgLength, height: bgLength)
        bgView.center = container.center
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor.lightGray
        container.addSubview(bgView)
        
        //转圈
        let indicatorLength:CGFloat = 40
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.startAnimating()
        bgView.addSubview(indicatorView)
        let indicatorViewX = bgLength / 2 - indicatorLength / 2
        let indicatorViewY = title.isEmpty ? bgLength / 2 - indicatorLength / 2 : indicatorLength * 0.4
        indicatorView.frame = CGRect(x: indicatorViewX , y: indicatorViewY , width: indicatorLength, height: indicatorLength)
        
        //添加文字
        let lableView = UILabel()
        lableView.frame = CGRect(x: 0, y: indicatorLength + indicatorLength * 0.3 , width: bgLength, height: bgLength - indicatorLength - indicatorLength * 0.4)
        lableView.font = UIFont.systemFont(ofSize: 15)
        lableView.textColor = UIColor.white
        lableView.text = title
        lableView.textAlignment = .center
        bgView.addSubview(lableView)
        
        if clickBgHidden {
            container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopLoading)))
        }
        
        let window = UIWindow() ///不用添加到其他地方就能显示
        window.frame = UIScreen.main.bounds
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindowLevelAlert ///显示等级
        window.isHidden = false
        window.addSubview(container)
        _window = window
    }
    
    ///关闭showLoadingText
    func stopLoading() {
        if let window = _window {
            window.isHidden = true
            window.resignKey()
        }
        _window = nil
    }
    
}
