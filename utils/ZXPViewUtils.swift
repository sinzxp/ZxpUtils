//
//  ZXPViewUtils.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/14.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPViewUtils: UIView {

}

class EffectView: UIView {
    
    let maskLayer = CALayer()
    var isNarrow = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("一根或者多根手指开始触摸view（手指按下）")
        self.alpha = 0.5
        if isNarrow {
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.9,y: 0.9))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("一根或者多根手指在view上移动（随着手指的移动，会持续调用该方法）")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("一根或者多根手指离开view（手指抬起）")
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            if self.isNarrow {
                self.layer.setAffineTransform(CGAffineTransform.identity)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("某个系统事件(例如电话呼入)打断触摸过程")
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            if self.isNarrow {
                self.layer.setAffineTransform(CGAffineTransform.identity)
            }
        }
    }
}
