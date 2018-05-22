//
//  user.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/2.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class Zuser: NSObject {
    
    public static let sharedInstance = Zuser()

    var Zimg:UIImage?
    
    func ccc() {
        UserDefaults.AccountInfo.set(value: "chilli cheng", forKey: .userName)
        UserDefaults.standard.clearAllUserDefaultsData()
        
    }

}
