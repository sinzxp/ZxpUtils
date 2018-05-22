//
//  HardwareTableViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/18.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import AudioToolbox

class HardwareTableViewController: UITableViewController {
    
    var  is监听设备方向的改变 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "传感器"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = UITableViewCell()
        if section == 0 {
            cell.textLabel?.text = "手机摇晃的监测和响应 (直接直接摇手机)"
        }
        if section == 1 {
            cell.textLabel?.text = "振动"
        }
        if section == 2 {
            cell.textLabel?.text = "声音"
        }
        if section == 3 {
            cell.textLabel?.text = "提醒"
        }
        if section == 4 {
            cell.textLabel?.text = "监听设备方向的改变 - \(is监听设备方向的改变 ? "开启中" : "关闭中")"
        }
        if section == 5 {
            cell.textLabel?.text = "加速传感器"
        }
        if section == 6 {
            cell.textLabel?.text = "播放视频"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 1 {
            //建立的SystemSoundID对象
            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
            //振动
            AudioServicesPlaySystemSound(soundID)
        }
        if section == 2 {
            
        }
        if section == 3 {
            //建立的SystemSoundID对象
            var soundID:SystemSoundID = 0
            //获取声音地址
            let path = Bundle.main.path(forResource: "msg", ofType: "wav")
            //地址转换
            let baseURL = NSURL(fileURLWithPath: path!)
            //赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
            //添加音频结束时的回调
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, { (soundID, inClientData) -> Void in
                let mySelf = Unmanaged<HardwareTableViewController>.fromOpaque(inClientData!).takeUnretainedValue()
                mySelf.audioServicesPlaySystemSoundCompleted(soundID)
            }, observer)
            
//            AudioServicesPlayAlertSound(soundID) //有震动
            AudioServicesPlaySystemSound(soundID) //无震动

        }
        if section == 4 {
            if !is监听设备方向的改变 {
                is监听设备方向的改变 = true
                //感知设备方向 - 开启监听设备方向 好像可以不加
                UIDevice.current.beginGeneratingDeviceOrientationNotifications()
                //添加通知，监听设备方向改变
                NotificationCenter.default.addObserver(self, selector: #selector(HardwareTableViewController.receivedRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            } else {
                is监听设备方向的改变 = false
                //关闭设备监听
//                UIDevice.current.endGeneratingDeviceOrientationNotifications()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            }
            self.tableView.reloadData()
            
        }
        
        if section == 5 {
            let vc = AccelerationSensorVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if section == 6 {
            let vc = AVPlayerController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    //音频结束时的回调
    func audioServicesPlaySystemSoundCompleted(_ soundID: SystemSoundID) {
        print("Completion")
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
    }
    
    //通知监听触发的方法
    func receivedRotation(){
        let device = UIDevice.current
        switch device.orientation {
        case .portrait:
            self.Toast.showToastExt("面向设备保持垂直，Home键位于下部")
        case .portraitUpsideDown:
            self.Toast.showToastExt("面向设备保持垂直，Home键位于上部")
        case .landscapeLeft:
            self.Toast.showToastExt("面向设备保持水平，Home键位于左侧")
        case .landscapeRight:
            self.Toast.showToastExt("面向设备保持水平，Home键位于右侧")
        case .faceUp:
            self.Toast.showToastExt("设备平放，Home键朝上")
        case .faceDown:
            self.Toast.showToastExt("设备平放，Home键朝下")
        case .unknown:
            self.Toast.showToastExt("方向未知")
        }
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("开始摇晃")
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("摇晃结束")
    }
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
         print("摇晃被意外终止")
    }
    
}

import CoreMotion

class AccelerationSensorVC:UIViewController {
    
    var ball:UIImageView!
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "传感器"
        self.view.backgroundColor = UIColor.white
        //放一个小球在中央
        ball = UIImageView(image:UIImage(named:"favorite_select"))
        ball.frame = CGRect(x:0, y:0, width:50, height:50)
        ball.center = self.view.center
        self.view.addSubview(ball)
        
        let uiswitch = UISwitch()
        //设置位置（开关大小无法设置）
        uiswitch.center = CGPoint(x:150, y:150)
        //设置默认值
        uiswitch.isOn = false
        uiswitch.addTarget(self, action: #selector(switchDidChange), for:.valueChanged)
        self.view.addSubview(uiswitch)
    }
    
    func switchDidChange(_ sswitch:UISwitch ){
        if sswitch.isOn {
            ssss()
        } else {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func ssss() {
        ///属性中设置通知间隔时间值。
        /*
         iPhone开发文档中推荐使用的通知间隔如下：
         （1）检测设备朝向：1/10 ~ 1/20
         （2）在游戏中需要实时使用加速传感器时：1/30 ~ 1/60
         （3）检测敲击设备或者剧烈摇动设备的情况下：1/70 ~ 1/100
        */
        motionManager.accelerometerUpdateInterval = 1/10
        ///加速度计可用
        if motionManager.isAccelerometerAvailable {
            let queue = OperationQueue.current
            motionManager.startAccelerometerUpdates(to: queue!) { (accelerometerData, error) in
                print("\(accelerometerData!.acceleration)")
                //动态设置小球位置
                self.speedX += accelerometerData!.acceleration.x
                self.speedY +=  accelerometerData!.acceleration.y
                var posX=self.ball.center.x + CGFloat(self.speedX)
                var posY=self.ball.center.y - CGFloat(self.speedY)
                //碰到边框后的反弹处理
                if posX<0 {
                    posX=0;
                    //碰到左边的边框后以0.4倍的速度反弹
                    self.speedX *= -0.4
                    
                }else if posX > self.view.bounds.size.width {
                    posX=self.view.bounds.size.width
                    //碰到右边的边框后以0.4倍的速度反弹
                    self.speedX *= -0.4
                }
                if posY<0 {
                    posY=0
                    //碰到上面的边框不反弹
                    self.speedY=0
                } else if posY>self.view.bounds.size.height{
                    posY=self.view.bounds.size.height
                    //碰到下面的边框以1.5倍的速度反弹
                    self.speedY *= -1.5
                }
                self.ball.center = CGPoint(x:posX, y:posY)
            }
        }
    }
    
}

import AVKit
import AVFoundation

class AVPlayerController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //定义一个视频文件路径
        let filePath = Bundle.main.path(forResource: "VID_20151007_112528", ofType: "mp4")!
        let vv = AVPlayerView(filePath,frame: CGRect(x: 0, y: 64, width: ZSCREEN_WIDTH, height: 300))
        self.view.addSubview(vv)

    }
    
    func playerDidFinishPlaying() {
        print("播放完毕!")
    }
    
}
