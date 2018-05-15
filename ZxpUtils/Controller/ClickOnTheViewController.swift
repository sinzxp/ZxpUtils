//
//  ClickOnTheViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/14.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ClickOnTheViewController: UIViewController {
    
    let vview = UILabel()
    let eview = EffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "点击手势 触摸事件"
        self.view.backgroundColor = UIColor.white
        eview.frame = self.view.bounds
        eview.backgroundColor = UIColor.alizarin()
        eview.isNarrow = false
        self.view.addSubview(eview)
        eview.addTapViewGesture(self, action: #selector(handleTapGesture))
        eview.addLongPressGesture(self, action: #selector(handleLongpressGesture))
        eview.addPinchGesture(self, action: #selector(handlePinchGesture))
        eview.addRotationGesture(self, action: #selector(handleRotateGesture))
        eview.addSwipeGesture(self, action: #selector(handleSwipeGesture), isLeft: true, isRight: true, isUp: true, isDown: true)

        vview.addPanGesture(self, action: #selector(handlePanGesture))
        vview.frame.size = CGSize(width: 100, height: 100)
        vview.center = self.view.center
        vview.backgroundColor = UIColor.blue
        vview.text = "哈"
        vview.textAlignmentCenter()
        self.view.addSubview(vview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        print("点击")
    }
    
    //长按手势
    func handleLongpressGesture(sender : UILongPressGestureRecognizer) {
        //state 手势识别器的当前状态。
        if sender.state == UIGestureRecognizerState.ended {
            print("长按结束")
        } else if sender.state == UIGestureRecognizerState.began {
            print("长按开始")
        }
    }
    
    //捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
    func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
//        print("factor ---> \(factor)")
        vview.transform = CGAffineTransform(scaleX: factor, y: factor)
        if sender.state == UIGestureRecognizerState.ended {
            print("捏的结束")
            vview.transform = CGAffineTransform.identity
        } else if sender.state == UIGestureRecognizerState.began {
            print("捏的开始")
        }
    }
    
    //旋转手势
    func handleRotateGesture(sender: UIRotationGestureRecognizer) {
        //浮点类型，得到sender的旋转度数
        let rotation = sender.rotation
//        print("rotation ---> \(rotation)")
        //旋转角度CGAffineTransformMakeRotation,改变图像角度
        vview.transform = CGAffineTransform(rotationAngle: rotation)
        if sender.state == UIGestureRecognizerState.ended {
            print("旋转结束")
            vview.transform = CGAffineTransform.identity
        } else if sender.state == UIGestureRecognizerState.began {
            print("旋转开始")
        }
    }
    
    //划动手势
    func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch direction {
        case .left:
            print("Left")
            vview.frame.origin.x = vview.x - 10
            break
        case .right:
            print("Right")
            vview.frame.origin.x = vview.x + 10
            break
        case .up:
            print("Up")
            vview.frame.origin.y = vview.y - 10
            break
        case .down:
            print("Down")
            vview.frame.origin.y = vview.y + 10
            break
        default:
            break;
        }
        if sender.state == UIGestureRecognizerState.ended {
            print("划动手势结束")
        } else if sender.state == UIGestureRecognizerState.began {
            print("划动手势开始")
        }
    }
    
    //拖手势
    func handlePanGesture(sender: UIPanGestureRecognizer){
        //得到拖的过程中的xy坐标
        let translation = sender.translation(in: vview)
//        print("translation ---> \(translation)")
        //平移图片CGAffineTransformMakeTranslation
        vview.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }

}
