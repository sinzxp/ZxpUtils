//
//  AVPlayerView.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/5/22.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AVPlayerView: UIView {
    
    //媒体资源管理对象，管理一些基本信息和状态
    var playerItem:AVPlayerItem!
    //视频操作对象
    var player:AVPlayer?
    
    init(_ filePath:String ,frame: CGRect) {
        super.init(frame:frame)
        setAVPlayer(filePath)
        operationButton()
        self.backgroundColor = UIColor.blue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func operationButton() {
        let play = UIView()
        play.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        play.backgroundColor = UIColor.green
        self.addSubview(play)
        play.addTapViewGesture(self, action: #selector(onPlay))

        let pause = UIView()
        pause.frame = CGRect(x: 0, y: 50, width: 50, height: 50)
        pause.backgroundColor = UIColor.yellow
        self.addSubview(pause)
        pause.addTapViewGesture(self, action: #selector(onPause))

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setAVPlayer(_ filePath:String) {
        //定义一个视频文件路径
//        let filePath = Bundle.main.path(forResource: "VID_20151007_112528", ofType: "mp4")
        let videoURL = URL(fileURLWithPath: filePath)
        //定义一个playerItem，并监听相关的通知
        self.playerItem = AVPlayerItem(url: videoURL)
        NotificationCenter.default.addObserver(self,selector: #selector(AVPlayerView.playerDidFinishPlaying),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: playerItem)
        //定义一个视频播放器，通过playerItem径初始化 将视频资源赋值给视频播放对象
        self.player = AVPlayer(playerItem: playerItem)
        //设置大小和位置
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        //添加到界面上
        self.layer.addSublayer(playerLayer)
//        print("\(player?.currentTime())")
        playerItem.loadedTimeRanges
    }
    
    func playerDidFinishPlaying(_ info:NSNotification) {
        if let item = info.object as? AVPlayerItem {
            print("播放完毕!")
        }
    }
    
    func onPlay() {
        //开始播放
        player?.play()
    }
    
    func onPause() {
        //开始播放
        player?.pause()
    }
    
    deinit{
//        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
//        playerItem.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }

}
