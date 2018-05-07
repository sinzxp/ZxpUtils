//
//  ZXPColor.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/7.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPColor: NSObject {

}

//MARK: - 返回随机颜色
extension UIColor {
    ///返回随机颜色
    open class var randomColor:UIColor{
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    ///苹果蓝
    class var appleBlue:UIColor{
        get {
            return UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        }
    }
    
}
