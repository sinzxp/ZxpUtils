//
//  ZXPImagePickerVCViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/18.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

class ZXPImagePickerVC: UIViewController {
    
    var imageRequestID:PHImageRequestID?
    var progressView = UIProgressView()
    var actionSheet = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///加载原图
    func loadOriginalImg(_ asset:PHAsset , cell:ZXPImagePickerGridCell) {
        showProgressView()
        let opt = PHImageRequestOptions()
        opt.isSynchronous = false
        opt.isNetworkAccessAllowed = true
        opt.progressHandler = progress
        imageRequestID = PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize , contentMode: . default, options: opt, resultHandler: { (image, info) in
            let ss = info!["PHImageCancelledKey"] as? Int
//            let sss = info!["PHImageErrorKey"]
//            print("【【【【【【\(info) ---- \(sss)】】】】】")
            if ss == 1 || image == nil {
                print("下载失败")
            } else {
                cell.islocalImg()
            }
            self.imageRequestID = nil
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        })
    }
    
    ///取消下载
    func cancelImageload() {
        if let imageRequestID = imageRequestID {
            PHImageManager.default().cancelImageRequest(imageRequestID)
        }
    }
    
    ///进度
    func progress(progress:Double, error:Error?, stop:UnsafeMutablePointer<ObjCBool>, info:[AnyHashable : Any]?) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.progressView.setProgress(Float(progress),animated:true)
        })
    }
    
    func showProgressView() {
        let rootView = UIView()
        rootView.addSubview(progressView)
        rootView.frame = CGRect(x: 0, y: 44, width: 270, height: 40)
        progressView.frame = CGRect(x: 5, y: 5, width: 260, height: 20)
        progressView.progress = 0
        progressView.layer.position = CGPoint(x: rootView.frame.width/2, y: 20)
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        //        progressView.progressTintColor = UIColor.
        progressView.trackTintColor = UIColor.lightGray
        actionSheet = UIAlertController(title: "正在获取", message: "\n", preferredStyle: UIAlertControllerStyle.alert)
        actionSheet.view.addSubview(rootView)
        let comfirmAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.destructive) { (action) -> Void in
            self.cancelImageload()
        }
        actionSheet.addAction(comfirmAction)
        self.present(actionSheet, animated: true) { () -> Void in}
    }

}
