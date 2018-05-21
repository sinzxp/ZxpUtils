//
//  ZXPCopyLabel.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/21.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

///长按可复制text的UILabel
class ZXPCopyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu(_:))))
    }
    
    func showMenu(_ sender: UILongPressGestureRecognizer) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
//        let mail = UIMenuItem(title: "邮件", action: #selector(onMail))
//        let weixin = UIMenuItem(title: "微信", action: #selector(onWeiXin))
//        menu.menuItems = [mail,weixin]
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    //复制
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
    
    ///焦点
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
//        if action == #selector(onWeiXin) {
//            return true
//        }
//        if action == #selector(onMail) {
//            return true
//        }
        return false
    }
    
//    func onMail(){
//        print("mail")
//    }
//
//    func onWeiXin(){
//        print("weixin")
//    }
    
}
