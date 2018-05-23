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

///自定义AVPlayer
class AVPlayerView: UIView {
    
    //媒体资源管理对象，管理一些基本信息和状态
    var playerItem:AVPlayerItem!
    //视频操作对象
    var player:AVPlayer!
    //可拖动的进度条
    private let controlsView = UIView()
    private var playbackSlider: UISlider!
    private var progressView:UIProgressView!
    private var playButton:UIButton!
    private var timeLabel:UILabel!
    private var aindicatorView:UIActivityIndicatorView!
    private var changePlayerItemButton:UIButton!
    fileprivate var changePlayerTableView:UITableView!
    fileprivate var itemIndex = 0

    /// 视频连接
    var filePaths:[String] = []
    /// 视频连接名称
    var filePathNames:[String] = []
    ///自动播放
    var isAutoPlayimg = false
    ///滑块滑动是视屏是否同步改变画面
    var isSyncDisplayScreen = false
    ///播放结束后进度条回到到开头
    var isPlayEndToTimeZero = false
    ///循环播放
    var isAutomaticCyclePlay = false
    ///拖拽滑块时是否在播放 用来判断拖拽完后是否自动播放
    private var isDragingSliderIsPlaying = false
    private var periodicTimeObserver:Any?
    
//    init(_ filePaths:[String] ,frame: CGRect) {
//        super.init(frame:frame)
//        self.filePaths = filePaths
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        operationButton()
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func operationButton() {
        playButton = UIButton()
        timeLabel = UILabel()
        progressView = UIProgressView()
        playbackSlider = UISlider()
        aindicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        changePlayerItemButton = UIButton()
        changePlayerTableView = UITableView()
        
        controlsView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        timeLabel.text = "00:00/00:00"
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .right
        timeLabel.font = FONT_NORMAL
        timeLabel.adjustsFontSizeToFitWidth = true
        progressView.backgroundColor = UIColor.lightGray
        progressView.tintColor = UIColor.appleBlue
        progressView.progress = 0
        playbackSlider.maximumTrackTintColor = UIColor.clear
        playbackSlider.minimumTrackTintColor = UIColor.white
        aindicatorView.startAnimating()
        changePlayerItemButton.setImage(UIImage(named: "avplaymenu"), for: UIControlState.normal)
        changePlayerTableView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        changePlayerTableView.alpha = 0
        playButton.setImage(UIImage(named: "blplay"), for: UIControlState.selected)
        playButton.setImage(UIImage(named: "blsuspended"), for: UIControlState.normal)
        playButton.isSelected = true
//        playbackSlider.setThumbImage(UIImage(named: "xyd"), for: UIControlState.normal)
//        playbackSlider.trackRect(forBounds: CGRect(x: 0, y: 0, width: 10, height: 10))

        self.addSubview(controlsView)
        controlsView.addSubview(playButton)
        controlsView.addSubview(timeLabel)
        controlsView.addSubview(progressView)
        controlsView.addSubview(playbackSlider)
        self.addSubview(aindicatorView)
        self.addSubview(changePlayerItemButton)
        self.addSubview(changePlayerTableView)

        aindicatorView.centerView(self)
        aindicatorView.aspectRatio("30")

        controlsView.bottomAlign(self, predicate: "0")
        controlsView.leadingAlign(self, predicate: "0")
        controlsView.trailingAlign(self, predicate: "0")
        controlsView.heightConstrain("35")

        playButton.topAlign(controlsView, predicate: "0")
        playButton.bottomAlign(controlsView, predicate: "0")
        playButton.leadingAlign(controlsView, predicate: "10")
        playButton.aspectRatio()
        
        timeLabel.topAlign(controlsView, predicate: "0")
        timeLabel.bottomAlign(controlsView, predicate: "0")
        timeLabel.trailingAlign(controlsView, predicate: "-10")
        timeLabel.width(controlsView, predicate: "*0.2")
        
        playbackSlider.leadingConstrain(playButton, predicate: "10")
        playbackSlider.trailingConstrain(timeLabel, predicate: "-10")
        playbackSlider.centerY(controlsView)
        playbackSlider.heightConstrain("20")
        
        progressView.topAlign(playbackSlider, predicate: "10")
        progressView.leadingAlign(playbackSlider, predicate: "0")
        progressView.trailingAlign(playbackSlider, predicate: "0")
        progressView.heightConstrain("2")
        
        changePlayerItemButton.topAlign(self, predicate: "10")
        changePlayerItemButton.trailingAlign(self, predicate: "-10")
        changePlayerItemButton.heightConstrain("30")
        changePlayerItemButton.aspectRatio()
        
        changePlayerTableView.bottomConstrain(controlsView, predicate: "0")
        changePlayerTableView.topAlign(self, predicate: "0")
        changePlayerTableView.trailingAlign(self, predicate: "0")
        changePlayerTableView.width(self, predicate: "*0.3")
        
        playButton.addTarget(target: self, action: #selector(onPlay))
        changePlayerItemButton.addTarget(target: self, action: #selector(onChangePlayerItem))

    }
    
    ///设置完成后调用这个加载
    public func startAVPlayer() {
        if !filePaths.isEmpty {
            setAVPlayerItem(filePaths[0])
            if filePaths.count > 1 {
                initTableView()
            } else {
                changePlayerItemButton.isHidden = true
                changePlayerTableView.isHidden = true
            }
        }
    }
    
    ///销毁是要在vc中调用  删除periodicTimeObserver监听
    public func removeTimeObserver() {
        if let pto = self.periodicTimeObserver {
            player.removeTimeObserver(pto)
        }
        self.periodicTimeObserver = nil
    }
    
    ////显示或隐藏视频选择菜单
    public func onChangePlayerItem() {
        UIView.animate(withDuration: 0.2) {
            if self.changePlayerTableView.alpha == 0 {
                self.changePlayerTableView.alpha = 1
                self.changePlayerItemButton.alpha = 0
            } else {
                self.changePlayerTableView.alpha = 0
            }
        }
    }
    ///点击视频界面显示或隐藏控制菜单
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            if self.controlsView.alpha == 0 {
                self.controlsView.alpha = 1
                self.changePlayerItemButton.alpha = 1
            } else {
                self.controlsView.alpha = 0
                self.changePlayerTableView.alpha = 0
                self.changePlayerItemButton.alpha = 0
            }
        }
    }
    ///设置进度条
    private func setSlider() {
        //设置进度条相关属性
//        let seconds = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
//        let duration : CMTime = playerItem!.asset.duration
//        let seconds : Float64 = CMTimeGetSeconds(duration)
//        playbackSlider.minimumValue = 0
//        playbackSlider.maximumValue = 1
        playbackSlider.isContinuous = true
        // 按下的时候
        playbackSlider.addTarget(self, action: #selector(sliderTouchDown( _:)), for: UIControlEvents.touchDown)
        // 弹起的时候
        playbackSlider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: UIControlEvents.touchUpOutside)
        playbackSlider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: UIControlEvents.touchUpInside)
        playbackSlider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: UIControlEvents.touchCancel)
        //滑块滑动事件
        if isSyncDisplayScreen {
            playbackSlider.addTarget(self,action:#selector(sliderDidchange(_:)), for:UIControlEvents.valueChanged)
        }
    }
    
    ///滑块滑动是视屏是否显示画面
    public func sliderDidchange(_ slider:UISlider) {
        if self.player.status == AVPlayerStatus.readyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds(self.player.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            // 指定视频位置
            player.seek(to: seekTime)
        }
    }
    
    public func sliderTouchDown(_ slider:UISlider){
        if self.player.status == AVPlayerStatus.readyToPlay {
            if self.player.rate == 0 {
                isDragingSliderIsPlaying = false
            } else {
                isDragingSliderIsPlaying = true
                player.pause()
            }
        }
    }
    
    public func sliderTouchUpOut(_ slider:UISlider){
        if self.player.status == AVPlayerStatus.readyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds(self.player.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            player.seek(to: seekTime) { (b) in
                if self.isDragingSliderIsPlaying {
                    self.player.play()
                }
            }
        }
    }
    
    ///设置AVPlayerItem 可以直接输入filePath
    public func setAVPlayerItem(_ filePath:String) {
        //定义一个视频文件路径
        let videoURL = URL(fileURLWithPath: filePath)
        if let _ = self.player {
            removeObservers()
            self.playerItem = AVPlayerItem(url: videoURL)
            addObservers()
            ///切换当前播放的内容
            self.player.replaceCurrentItem(with: self.playerItem)
        } else {
            ///第一次
            //定义一个playerItem，并监听相关的通知
            self.playerItem = AVPlayerItem(url: videoURL)
            setAVPlayer()
            addObservers()
        }
    }
    
    ///设置AVPlayer
    private func setAVPlayer() {
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
        self.layer.insertSublayer(playerLayer, at: 0)
    }
    
    ///播放完毕
    public func playerDidFinishPlaying(_ info:NSNotification) {
        if let item = info.object as? AVPlayerItem {
            print("播放完毕!")
            if isPlayEndToTimeZero && !isAutomaticCyclePlay {
                item.seek(to: kCMTimeZero)
                playButtonStyle()
            }
            if isAutomaticCyclePlay {
                item.seek(to: kCMTimeZero) { (b) in
                    self.player.play()
                    self.playButtonStyle()
                }
            }
        }
    }
    
    ///开始播放
    public func onPlay() {
        if self.player.status == AVPlayerStatus.readyToPlay {
            // 只有在这个状态下才能播放
            if player.rate == 0 {
                self.player.play()
            } else {
                self.player.pause()
            }
            playButtonStyle()
        } else {
            print("加载异常")
        }
    }
    
    private func playButtonStyle() {
        if player.rate == 0 {
            playButton.isSelected = true
        } else {
            playButton.isSelected = false
        }
    }
    
    ///状态
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges"{
            // 缓冲进度
            // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime / totalTime // 计算出比例
            // 改变进度条
            self.progressView.progress = Float(percent)
            if playbackSlider.value > Float(percent) {
                aindicatorView.startAnimating()
            } else {
                aindicatorView.stopAnimating()
            }
        }else if keyPath == "status"{
            // 监听状态改变 只有在这个状态下才能播放
            if playerItem.status == AVPlayerItemStatus.readyToPlay {
                setSlider()
                update()
                if isAutoPlayimg {
                    self.player.play()
                    playButtonStyle()
                }
            }else{
                print("加载异常")
            }
        }
    }
    
    ///更新时间进度条
    private func update() {
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
    private func formatPlayTime(_ secounds:TimeInterval) -> String {
        if secounds.isNaN{
            return "00:00"
        }
        let all:Int = Int(secounds)
        let Sec:Int = all % 60
        let Min:Int = Int(all/60)
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    ///计算当前的缓冲进度
    private func avalableDurationWithplayerItem() -> TimeInterval{
        guard let loadedTimeRanges = player.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    deinit{
        print("销毁AVPlayerView")
        removeObservers()
        self.player.replaceCurrentItem(with: nil)
        self.playerItem = nil
        self.player = nil
    }
    
    private func removeObservers() {
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        player.currentItem?.cancelPendingSeeks()
        player.currentItem?.asset.cancelLoading()
    }
    
    private func addObservers() {
        //播放完毕通知
        NotificationCenter.default.addObserver(self,selector: #selector(playerDidFinishPlaying),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: playerItem)
        // 监听缓冲进度改变
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
}

extension AVPlayerView: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        self.changePlayerTableView.delegate = self
        self.changePlayerTableView.dataSource = self
        self.changePlayerTableView.disableSeparator()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filePaths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell: UITableViewCell = tableView.dequeueDynamicCell(reuseIdentifier: "AVPlayerViewCell")
        cell.textLabel?.text = "\(row + 1)." + "\(filePathNames.count > row ? filePathNames[row] : filePaths[row])"
        cell.textLabel?.textColor = self.itemIndex != row ? .white : .appleBlue
        cell.backgroundColor =  UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if filePaths.count - 1 >= row && self.itemIndex != row {
            self.itemIndex = row
            setAVPlayerItem(filePaths[row])
            tableView.reloadData()
        }

    }

}
