//
//  ZXPPermissionsUtils.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/16.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos


///权限
class ZXPPermissionsUtils {
    
    //MARK: - 跳转到app设置
    class public func toOpenSetting(_ title:String = "提示",message:String = "跳转到app设置") {
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
            alertController.atTheTopViewController()?.present(alertController, animated: true, completion: nil)
        })
    }
    
    public enum permissionsMediaType:String {
        case Video , Audio
    }
    
    //MARK: - 授权相册 麦克风 相机
    class public func isPermissions(_ mediaType: permissionsMediaType) -> Bool {
        var type:AVMediaType!
        if mediaType == permissionsMediaType.Audio {
            type = AVMediaTypeAudio as AVMediaType
        }
        if mediaType == permissionsMediaType.Video {
            type = AVMediaTypeVideo as AVMediaType
        }
        let status:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: type as String?)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: type as String?, completionHandler: {
                (status) in
                DispatchQueue.main.async(execute: { () -> Void in
                    _ = self.isPermissions(mediaType)
                })
            })
        default:
            var text = ""
            if mediaType == permissionsMediaType.Audio {
                text = "麦克风"
            }
            if mediaType == permissionsMediaType.Video {
                text = "相机"
            }
            self.toOpenSetting("访问\(text)受限", message: "点击“设置”，允许访问您\(text).")
        }
        return false
    }
    
    //MARK: - 授权相册
    class public func isPhotoLibraryPermissions(_ status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()) -> Bool {
        
        switch status {
        case .authorized:
            print("用户已经授权这个应用程序可以访问照片数据。")
            return true
        case .notDetermined:
            print("用户还没有对这个应用对访问照片库的权限的请求作出选择。")
            // 请求授权 第一次
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    _ = self.isPhotoLibraryPermissions(status)
                })
            })
//        case .denied:
//            print("用户已经明确的拒绝这个应用程序访问照片数据。")
//        case .restricted:
//            print("这个应用还没有被授权可以访问照片数据 用户不能改变这个应用的授权状态，可能是由于活动限制，例如家长控制模式。")
        default:
            self.toOpenSetting("访问相册受限", message: "点击“设置”，允许访问您的相册")
        }
        return false
    }
    
}

