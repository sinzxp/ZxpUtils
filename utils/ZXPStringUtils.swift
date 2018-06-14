//
//  ZXPStringUtils.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/21.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPStringUtils {

}

//MARK: - 去除字符串前后的空白
extension String {
    ///去除字符串前后的空白 自定义
    func removeBeforeAndAfter(_ characters:String ) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let str = self.trimmingCharacters(in: characterSet)
        return str
    }
    
    ///去除字符串前后的空白
    /*
     CharacterSet 里各个枚举类型的含义如下：
     controlCharacters：控制符
     whitespaces：空格
     newlines：换行符
     whitespacesAndNewlines：空格换行
     decimalDigits：小数
     letters：文字
     lowercaseLetters：小写字母
     uppercaseLetters：大写字母
     nonBaseCharacters：非基础
     alphanumerics：字母数字
     decomposables：可分解
     illegalCharacters：非法
     punctuationCharacters：标点
     capitalizedLetters：大写
     symbols：符号
     */
    func removeBeforeAndAfter(_ characterSet:CharacterSet ) -> String {
        let str = self.trimmingCharacters(in: characterSet)
        return str
    }
    
}

extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}

