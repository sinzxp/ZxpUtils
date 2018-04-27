//
//  AppAndDeviceInfoManager.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/27.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
///获取app和设备信息
class AppAndDeviceInfoManager: NSObject {

    //应用程序信息
    let infoDictionary = Bundle.main.infoDictionary!
    //包名
    let bundId = Bundle.main.bundleIdentifier!
    
    //程序名称
    var appName:String {
        get {
//            print("-------- \(infoDictionary["CFBundleName"]) ------")
            let name = infoDictionary["CFBundleDisplayName"]
            return "\(name == nil ? "" : name!)"
        }
    }
    // 获取App的版本号
    var appVersion:String {
        get {
            return "\(infoDictionary["CFBundleShortVersionString"]!)"
        }
    }
    // 获取App的build版本
    var appBuildVersion:String {
        get {
            return "\(infoDictionary["CFBundleVersion"]!)"
        }
    }
    
    //设备信息
    let iosVersion = UIDevice.current.systemVersion //iOS版本
    let identifierNumber = UIDevice.current.identifierForVendor //设备udid UUID
    let systemName = UIDevice.current.systemName //设备名称
    let model = UIDevice.current.model //设备型号
    let modelName = UIDevice.current.modelName //设备具体型号
    let localizedModel = UIDevice.current.localizedModel //设备区域化型号如A1533
    
    ///跳转到appstore
    class func toAPPStore(_ appId:String) {
        let urlString = "itms-apps://itunes.apple.com/app/id\(appId)"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    ///获取appstore中应用的信息
    class func getAPPStoreInfo(_ appId:String) -> Any? {
        let appurlStr:String = String.init(format: "https://itunes.apple.com/cn/lookup?id=%@", appId)
        let url:URL=URL.init(string: appurlStr)!
        do {
            let jsonData = try Data.init(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
            let res = json["results"]//APPstore信息
            print(json)
            return res
        } catch {
            return nil
        }
    }
    
}

//扩展UIDevice
extension UIDevice {
    //获取设备具体详细的型号 //缺少几个型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
