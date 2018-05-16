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

//MARK: - view点击效果 透明度 缩小
open class EffectView: UIView {
    
    var isNarrow = false
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("一根或者多根手指开始触摸view（手指按下）")
        self.alpha = 0.5
        if isNarrow {
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.9,y: 0.9))
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("一根或者多根手指在view上移动（随着手指的移动，会持续调用该方法）")
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("一根或者多根手指离开view（手指抬起）")
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            if self.isNarrow {
                self.layer.setAffineTransform(CGAffineTransform.identity)
            }
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("某个系统事件(例如电话呼入)打断触摸过程")
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            if self.isNarrow {
                self.layer.setAffineTransform(CGAffineTransform.identity)
            }
        }
    }
}

//MARK: - 点击事件 手势
public extension UIView {
    
    ///去除点击事件
    public func removeViewGesture() {
        self.isUserInteractionEnabled = false
    }
    
    ///单击
    public func addTapViewGesture(_ target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    ///双击
    public func addTapDoubleGesture(target: Any?, tapSingleDid: Selector?,tapDoubleDid: Selector?) {
        self.isUserInteractionEnabled = true
        //单击监听
        let tapSingle = UITapGestureRecognizer(target:target, action: tapSingleDid)
        tapSingle.numberOfTapsRequired = 1 //设置手势点击数
        tapSingle.numberOfTouchesRequired = 1  //设置手指数
        //双击监听
        let tapDouble = UITapGestureRecognizer(target:target, action: tapDoubleDid)
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        //声明点击事件需要双击事件检测失败后才会执行
        tapSingle.require(toFail: tapDouble)
        self.addGestureRecognizer(tapSingle)
        self.addGestureRecognizer(tapDouble)
    }
    
    ///长按
    public func addLongPressGesture(_ target: Any?, action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        //长按时间为1秒
        longPress.minimumPressDuration = 1
        //允许运动范围
        longPress.allowableMovement = 10
        //所需触摸1次
        longPress.numberOfTouchesRequired = 1
        self.addGestureRecognizer(longPress)
    }
    
    //手势为捏的姿势:按住option按钮配合鼠标来做这个动作在虚拟器上
    public func addPinchGesture(_ target: Any?, action: Selector) {
        self.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(pinchGesture)
    }
    
    //旋转手势:按住option按钮配合鼠标来做这个动作在虚拟器上
    public func addRotationGesture(_ target: Any?, action: Selector) {
        self.isUserInteractionEnabled = true
        let rotateGesture = UIRotationGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(rotateGesture)
    }
    
    //划动手势 和拖手势冲突
    public func addSwipeGesture(_ target: Any?, action: Selector, isLeft:Bool = false, isRight:Bool = true, isUp:Bool = false, isDown:Bool = false) {
        self.isUserInteractionEnabled = true
        if isLeft {
            let swipeGesture1 = UISwipeGestureRecognizer(target: target, action: action)
            swipeGesture1.direction = .left
            self.addGestureRecognizer(swipeGesture1)
        }
        if isRight {
            let swipeGesture2 = UISwipeGestureRecognizer(target: target, action: action)
            swipeGesture2.direction = .right
            self.addGestureRecognizer(swipeGesture2)
        }
        if isUp {
            let swipeGesture3 = UISwipeGestureRecognizer(target: target, action: action)
            swipeGesture3.direction = .up
            self.addGestureRecognizer(swipeGesture3)
        }
        if isDown {
            let swipeGesture4 = UISwipeGestureRecognizer(target: target, action: action)
            swipeGesture4.direction = .down
            self.addGestureRecognizer(swipeGesture4)
        }
    }
    
    //拖手势 和划动手势冲突
    public func addPanGesture(_ target: Any?, action: Selector) {
        self.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(panGesture)
    }
    
}

