//
//  ZXPAlertController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/20.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPAlertController: NSObject {

}

//MARK: - 系统弹窗
public extension UIViewController {
    
    public typealias indexBlock = ((_ index:Int)->())
    
    ///几秒后消失
    public func showActionTime(_ time:Int = 2, title: String,message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(time)) {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    public func showActionAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let comfirmAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.destructive) { (action) -> Void in
        }
        alertController.addAction(comfirmAction)
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    ///选择
    public func showActionSheet(_ titles:[String],title: String? = nil,message: String? = nil,handler:@escaping indexBlock) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for i in 0..<titles.count {
            let text = titles[i]
            let cancelAction = UIAlertAction(title: text, style: .default) { (action) in
                handler(i)
            }
            alertController.addAction(cancelAction)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    public typealias indexTextFieldBlock = ((_ textField:UITextField,_ index:Int)->())
    public typealias textFieldOkBlock = ((_ texts:[String:String])->())
    ///输入框
    public func showActionTextField(keys:[String],title: String? = nil,message: String? = nil,textFields:indexTextFieldBlock?,handler:textFieldOkBlock?) {
        let alertController = UIAlertController(title: title,  message: message, preferredStyle: .alert)
        for i in 0..<keys.count {
            let text = keys[i]
            alertController.addTextField { (textField: UITextField!) -> Void in
                textField.placeholder = text
                textFields?(textField,i)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: { action in
            var arr:[String:String] = [:]
            if let textFields = alertController.textFields {
                for item in 0..<textFields.count {
                    let text = keys[item]
                    let textField = textFields[item]
                    arr[text] = textField.text!
                }
                handler?(arr)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
    }
}
