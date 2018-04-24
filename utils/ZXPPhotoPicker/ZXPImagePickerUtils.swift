//
//  ZXPImagePickerUtils.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/4/18.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

class ZXPImagePickerUtils: NSObject {

}

extension UIViewController {
    
    ///跳转到设置
    func toOpenSetting(_ title:String,message:String) {
        DispatchQueue.main.async(execute: { () -> Void in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:  "取消", style: .cancel, handler:nil)
            let settingsAction = UIAlertAction(title: "设置", style: .destructive , handler: { (action) -> Void in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if let url = url , UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    ///相机权限
    func isCameraPermissions() -> Bool {
        if !cameraPermissions() {
            toOpenSetting("访问相机受限", message: "点击“设置”，允许使用您的相机")
            return false
        }
        return true
    }
    
    ///授权相册
    fileprivate func permissions(_ status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()) -> Bool {
        
        switch status {
        case .authorized:
            print("用户已经授权这个应用程序可以访问照片数据。")
            return true
        case .notDetermined:
            print("用户还没有对这个应用对访问照片库的权限的请求作出选择。")
            // 请求授权 第一次
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    _ = self.permissions(status)
                })
            })
//        case .denied:
//            print("用户已经明确的拒绝这个应用程序访问照片数据。")
//        case .restricted:
//            print("这个应用还没有被授权可以访问照片数据 用户不能改变这个应用的授权状态，可能是由于活动限制，例如家长控制模式。")
        default:
            print("\(status)")
            toOpenSetting("访问相册受限", message: "点击“设置”，允许访问您的相册")
        }
        return false
    }
    
    func presentImagePicker(maxSelected:Int,handler:@escaping (_ images:[UIImage])->()) {
        guard permissions() else {
            return
        }
        let vc = ZXPImagePickerTableVC()
        vc.completeHandlerIMG = handler
        vc.maxSelected = maxSelected
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentAssetsPicker(maxSelected:Int,handler:@escaping (_ assets:[PHAsset])->()) {
        guard permissions() else {
            return
        }
        let vc = ZXPImagePickerTableVC()
        vc.completeHandlerPHA = handler
        vc.maxSelected = maxSelected
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}
