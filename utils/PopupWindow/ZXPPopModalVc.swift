//
//  ZXPPopModalVc.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/20.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

public class ZXPPopModalVc: UIViewController {
    
    override public func viewDidLoad() {
        self.modalTransitionStyle = .crossDissolve //转场样式
        self.modalPresentationStyle = .overFullScreen  //这个可以透明 还有其他
//        print("viewDidLoad------ \(atTheTopViewController())")
        
        /*
         present延迟,加上perform就ok拉 perform可以什么都不用做
         perform将主线程唤醒执行
         在主线程更新UI也可以
         */
        self.perform(#selector(wakeUpTheerform), with: self, afterDelay: 0)
    }
    
    func wakeUpTheerform() {
//        print("perform------ 唤醒present")
    }
    
//    public override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear------ \(atTheTopViewController())")
//    }
//
//    public override func viewDidAppear(_ animated: Bool) {
//        print("viewDidAppear------ \(atTheTopViewController())")
//    }
    
    ///关闭
    public func toDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///开始跳转 加载完vc自动跳
    public func toPresent() {
        if let vc = atTheTopViewController() {
//            print("toPresent------ \(atTheTopViewController())")
            if let _ = vc as? ZXPPopModalVc {
//                vv.toDismiss() ///清除前面的弹窗
                self.view.backgroundColor = UIColor.clear
            } else {
                self.view.backgroundColor = setbackgroundColor()
            }
            ///present延迟,在主线程更新UI即可 同时加载不了多过改用perform
//            DispatchQueue.main.async(execute: { () -> Void in
                vc.present(self, animated: true, completion: nil)
//            })
            print("ok")
        } else {
            print("no")
        }
    }
    
    public func setContentView(_ view:UIView,isClickBackgroundDismiss:Bool = true) {
        self.view.addSubview(view)
        view.center = self.view.center
        if isClickBackgroundDismiss {
            self.view.addTapViewGesture(self, action: #selector(toDismiss))
        }
    }
    
    ///背景颜色
    func setbackgroundColor() -> UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }

}

extension NSObject {
    ///弹窗
    func showTextTime(_ text:String,_ time:DispatchTime = 2) {
        let pvc = ZXPPopModalVc()
        let view = UILabel()
        view.text = text
        view.textAlignment = .center
        view.backgroundColor = UIColor.white
        view.frame.size = CGSize(width: ZSCREEN_WIDTH * 0.6, height: ZSCREEN_HEIGHT * 0.1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        pvc.setContentView(view, isClickBackgroundDismiss: false)
        pvc.toPresent()
        delayPerform(time) {
            pvc.toDismiss()
        }
    }
    
}
//public class ZXPPopModal: NSObject {
//
//    let pvc = ZXPPopModalVc()
//
//    func presentModalView(_ view:UIView) {
//        if let vc = atTheTopViewController() {
//            pvc.view.backgroundColor = setbackgroundColor()
//            pvc.setContentView(view, isClickBackgroundDismiss: false)
//            vc.present(pvc, animated: true, completion: nil)
//        }
//    }
//
//    func setbackgroundColor() -> UIColor {
//        return UIColor.black.withAlphaComponent(0.3)
//    }
//}

