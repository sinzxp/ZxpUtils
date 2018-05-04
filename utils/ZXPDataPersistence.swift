//
//  ZXPDataPersistence.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/4.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
///数据持久化
class ZXPDataPersistence: NSObject {
    

}

// Swift 中可以对协议 protocol 进行扩展, 提供协议方法的默认实现, 如果遵守协议的类/结构体/枚举实现了该方法, 就会覆盖掉默认的方法.
//https://www.jianshu.com/p/3796886b4953
protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue == String {
    
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
    
    static func set(value: Any?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static func string(forKey key: defaultKeys) -> Any? {
        let aKey = key.rawValue
        return UserDefaults.standard.object(forKey: aKey)
    }
    
    static func removeObject(forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.removeObject(forKey: aKey)
    }
}

extension UserDefaults {
    // 账户信息
    struct AccountInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case userName
            case age
        }
    }
    
    // 登录信息
    struct LoginInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case token
            case userId
        }
    }
}
