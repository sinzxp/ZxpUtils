//
//  ZXPToastView.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/2.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

///UIWindow Toast 弹窗
class ZXPToastView: NSObject {
    
    //显示位置
    enum Position: Int {
        case Top
        case Mid
        case Bottom
    }
    
    var delay: Double = 5.0  //延迟时间
    
    var windows: [UIWindow] = []  //缓存window
    
    func showLoadingText(_ title:String = "" ,delay:Double = 5.0) {
        
        let container = UIView()   
        container.backgroundColor = UIColor.clear
        container.frame = UIScreen.main.bounds
        
        let bgLength: CGFloat = 90.0
        let bgView = UIView()
        bgView.frame.size = CGSize(width: bgLength, height: bgLength)
        bgView.center = container.center
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
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
        show(container)
    }
    
    func showToast(_ title:String = "" ,delay:Double = 1.0 ,position:Position = .Mid, modal:Bool = true) {

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
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
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
            bgView.frame.origin.y = ZSCREEN_HEIGHT * 0.9 - (lableViewSize.height + 20) / 2
        }

        lableView.frame = CGRect(x: 10, y: 10 , width: lableViewSize.width, height: lableViewSize.height)
        bgView.addSubview(lableView)
        
        show(container)
    }
    
    func showToastExt() {
        
    }
    
    func show(_ view:UIView){
        let window = UIWindow() ///不用添加到其他地方就能显示
        window.frame = UIScreen.main.bounds
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindowLevelAlert ///显示等级
        window.alpha = 1
        window.isHidden = false
        window.addSubview(view)
        self.windows.append(window)
        self.perform(#selector(showShutDown(sender:)), with: window, afterDelay: delay)
    }
    
    
    //添加点击事件
    func tapGesture(sender: UITapGestureRecognizer) {
        print("点击uiview")
        
        //移除最后一个
        if windows.count > 0 {
            windows.removeLast()
        }
        ///清除延时执行
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    //toast超时关闭
    func showShutDown(sender: AnyObject) {
        if let window = sender as? UIWindow {
            if let index = windows.index(of: window) {
                windows.remove(at: index)  //删除
            }
        } else {
            //do nothing
        }
    }
    
    //关闭所有
    func showShutDownAll() {
        windows.removeAll()
    }
    
///    删除window
//    private func hide(){
//        window.hidden = true
//        window.resignKeyWindow()
//        _window = nil
//    }

}
