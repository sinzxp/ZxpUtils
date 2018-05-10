//
//  QPCacheUtils.swift
//  QHProject
//
//  Created by quickplain on 15/12/24.
//  Copyright © 2015年 quickplain. All rights reserved.
//

import UIKit
import CryptoSwift

public class QPCacheUtils: NSObject {
	
    public static let sharedInstance = QPCacheUtils()


	public var container = NSMutableDictionary()

	public class func cache(value: AnyObject, forKey : String) {
		QPCacheUtils.cache(value: value, forKey: forKey, toDisk: false)
	}

	public class func cache(value: AnyObject, forKey : String, toDisk: Bool) {
		let newKey = forKey.md5()
//        let newKey = (forKey as NSString).encryptToAESString()
//		print("cache \(forKey) \(newKey) \(value)")
		QPCacheUtils.sharedInstance.container.setObject(value, forKey: newKey as NSCopying)
		if toDisk {
            let userDefault = UserDefaults.standard
			userDefault.set(value, forKey: newKey)
		}
	}

	public class func getCacheBy(key: String) -> AnyObject? {

		let newKey = key.md5() //
//		print("getCacheBy \(key) \(newKey)")
		let obj = QPCacheUtils.sharedInstance.container[newKey]
		if obj == nil {
			let userDefault = UserDefaults.standard
			let value = userDefault.object(forKey: newKey)
			return value as AnyObject
		} else {
			return obj as AnyObject
		}
	}

	public class func isExist(key: String) -> Bool {
//        let newKey = (key as NSString).encryptToAESString()
		let newKey = key.md5() //
//		print("isExist \(key) \(newKey)")
		if let _ = QPCacheUtils.sharedInstance.container[newKey] {
			return true
		} else {
            let userDefault = UserDefaults.standard
			if let _ = userDefault.object(forKey: newKey) {
				return true
			}
			return false
		}
	}
}

public extension NSObject {
	private func appendingKey() -> String {
//		return "\(HOST)-\(QPMemberUtils.sharedInstance.memberId)"
        return "hhhh"
	}

	public func cacheBy(key : String) -> AnyObject? {
		let newKey = key + appendingKey()
		return QPCacheUtils.getCacheBy(key: newKey)
	}

	public func cache(cacheObject: AnyObject!, forKey: String!) {
		let newKey = forKey + appendingKey()
//		QPCacheUtils.cache(cacheObject, forKey: newKey)
        QPCacheUtils.cache(value: cacheObject, forKey: newKey)
	}

	public func cacheToDisk(cacheObject: AnyObject!, forKey: String!) {
		let newKey = forKey + appendingKey()
		QPCacheUtils.cache(value: cacheObject, forKey: newKey, toDisk: true)
	}

	public func cacheIsExist(key: String) -> Bool {
		let newKey = key + appendingKey()
		return QPCacheUtils.isExist(key: newKey)
	}
}
