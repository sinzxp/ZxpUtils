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
    var player:AVPlayer!
    //可拖动的进度条
    var playbackSlider: UISlider!
    var progressView:UIProgressView!
    var playButton:UIButton!
    var timeLabel:UILabel!
    
    var autoPlayimg = false
    
    var periodicTimeObserver:Any?

    init(_ filePath:String ,frame: CGRect) {
        super.init(frame:frame)
        operationButton()
        setAVPlayer(filePath)
        self.backgroundColor = UIColor.black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func operationButton() {
        let contentView = UIView()
        playButton = UIButton()
        timeLabel = UILabel()
        progressView = UIProgressView()
        playbackSlider = UISlider()
        
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        playButton.backgroundColor = UIColor.red
        timeLabel.text = "00:00/00:00"
        timeLabel.textColor = UIColor.white
        progressView.backgroundColor = UIColor.lightGray
        progressView.tintColor = UIColor.red
        progressView.progress = 0
        playbackSlider.maximumTrackTintColor = UIColor.clear
        playbackSlider.minimumTrackTintColor = UIColor.white
        
        self.addSubview(contentView)
        contentView.addSubview(playButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(playbackSlider)

        contentView.bottomAlign(self, predicate: "0")
        contentView.leadingAlign(self, predicate: "0")
        contentView.trailingAlign(self, predicate: "0")
        contentView.heightConstrain("30")

        playButton.topAlign(contentView, predicate: "0")
        playButton.bottomAlign(contentView, predicate: "0")
        playButton.leadingAlign(contentView, predicate: "10")
        playButton.aspectRatio()
        
        timeLabel.topAlign(contentView, predicate: "0")
        timeLabel.bottomAlign(contentView, predicate: "0")
        timeLabel.trailingAlign(contentView, predicate: "-10")
        
        playbackSlider.leadingConstrain(playButton, predicate: "10")
        playbackSlider.trailingConstrain(timeLabel, predicate: "-10")
        playbackSlider.centerY(contentView)
        playbackSlider.heightConstrain("20")
        
        progressView.leadingAlign(playbackSlider, predicate: "0")
        progressView.trailingAlign(playbackSlider, predicate: "0")
        progressView.centerY(playbackSlider)
        progressView.heightConstrain("20")
        
        playButton.addTarget(target: self, action: #selector(onPlay))

    }
    
    ///进度条
    func setSlider() {
        //设置进度条相关属性
//        let seconds = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
//        let duration : CMTime = playerItem!.asset.duration
//        let seconds : Float64 = CMTimeGetSeconds(duration)
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = 1
        playbackSlider.isContinuous = false
        // 按下的时候
        playbackSlider.addTarget(self, action: #selector(sliderTouchDown( _:)), for: UIControlEvents.touchDown)
        // 弹起的时候
        playbackSlider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: UIControlEvents.touchUpOutside)
        playbackSlider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: UIControlEvents.touchUpInside)
        playbackSlider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: UIControlEvents.touchCancel)
    }
    
    func sliderTouchDown(_ slider:UISlider){
        player.pause()
    }
    
    func sliderTouchUpOut(_ slider:UISlider){
        if self.player.status == AVPlayerStatus.readyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds(self.player.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            // 指定视频位置
            player.seek(to: seekTime) { (b) in
                if self.player.rate == 0 {
                    self.player.play()
                }
            }
        }
    }
    
    func setAVPlayer(_ filePath:String) {
        //定义一个视频文件路径
        let videoURL = URL(fileURLWithPath: filePath)
        //定义一个playerItem，并监听相关的通知
        self.playerItem = AVPlayerItem(url: videoURL)
        //播放完毕通知
        NotificationCenter.default.addObserver(self,selector: #selector(AVPlayerView.playerDidFinishPlaying),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: playerItem)
        // 监听缓冲进度改变
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        //定义一个视频播放器，通过playerItem径初始化 将视频资源赋值给视频播放对象
        self.player = AVPlayer(playerItem: playerItem)
        //播放过程中动态改变进度条值和时间标签
        self.periodicTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: DispatchQueue.main) { (t) in
            if self.player!.currentItem?.status == .readyToPlay {
                //更新进度条进度值
                self.update()
            }
        }
        //设置大小和位置
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
//        player.rate = 2
        // 设置显示模式 重力感应
//        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        //添加到界面上
        self.layer.addSublayer(playerLayer)
    }
    
    func playerDidFinishPlaying(_ info:NSNotification) {
        if let item = info.object as? AVPlayerItem {
            print("播放完毕!")
            item.seek(to: kCMTimeZero) { (b) in
//                self.player.play()
            }
        }
    }
    
    ///开始播放
    func onPlay() {
        if playerItem.status == AVPlayerItemStatus.readyToPlay {
            // 只有在这个状态下才能播放
            if player.rate == 0 {
                self.player.play()
            } else {
                self.player.pause()
            }
        }else{
            print("加载异常")
        }
    }
    
    ///状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges"{
            // 缓冲进度
            // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime / totalTime // 计算出比例
            // 改变进度条
            self.progressView.progress = Float(percent)
            print("11111")
        }else if keyPath == "status"{
            // 监听状态改变 只有在这个状态下才能播放
            if playerItem.status == AVPlayerItemStatus.readyToPlay {
                setSlider()
                if autoPlayimg {
                    onPlay()
                }
            }else{
                print("加载异常")
            }
        }
    }
    
    ///更新时间进度条
    func update() {
        // 当前播放到的时间
        let currentTime = CMTimeGetSeconds(self.player.currentTime())
        // 总时间 timescale 这里表示压缩比例
//        let totalTime = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        let totalTime = CMTimeGetSeconds(self.playerItem.duration)
        let timeStr = "\(formatPlayTime(currentTime))/\(formatPlayTime(totalTime))" // 拼接字符串
        self.timeLabel.text = timeStr // 赋值
        self.playbackSlider.value = Float(currentTime/totalTime)
    }
    
    ///时间转换
    func formatPlayTime(_ secounds:TimeInterval) -> String {
        if secounds.isNaN{
            return "00:00"
        }
        let all:Int = Int(secounds)
        let Sec:Int = all % 60
        let Min:Int = Int(all/60)
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    ///计算当前的缓冲进度
    func avalableDurationWithplayerItem() -> TimeInterval{
        guard let loadedTimeRanges = player.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    deinit{
        print("销毁AVPlayerView")
        if let pto = self.periodicTimeObserver {
            player.removeTimeObserver(pto)
        }
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    ///CADisplayLink 的执行次数相当于屏幕的帧数，iPhone 不卡顿的时候是每秒60次。把它加入主loop中，默认Mode 。差不多每秒执行60次。
//    var link:CADisplayLink!
//
//    func onLink() {
//        self.link = CADisplayLink(target: self, selector: #selector(update))
//        self.link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
//    }

}
