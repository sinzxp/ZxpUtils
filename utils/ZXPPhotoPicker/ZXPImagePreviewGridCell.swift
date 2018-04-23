//
//  ZXPImagePreviewCell.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/4.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

class ZXPImagePreviewGridCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    var scrollView:UIScrollView!
    var downloadIcon = UIImageView()
    var coverView = UIView()
    
    var isICloud:Bool = false {
        didSet {
            setIsClickImage()
        }
    }
    
    public func setup() {
        //scrollView初始化
        scrollView = UIScrollView(frame: contentView.bounds)
        contentView.addSubview(scrollView)
        scrollView.delegate = self
        //scrollView缩放范围 1~3
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        //  展示图片
        imageView = UIImageView(frame: scrollView.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.clear
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        
        contentView.backgroundColor = UIColor.clear
        
        //单击监听
        let tapSingle = UITapGestureRecognizer(target:self, action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        //双击监听
        let tapDouble = UITapGestureRecognizer(target:self, action:#selector(tapDoubleDid))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        //声明点击事件需要双击事件检测失败后才会执行
        tapSingle.require(toFail: tapDouble)
        self.imageView.addGestureRecognizer(tapSingle)
        self.imageView.addGestureRecognizer(tapDouble)
        
        contentView.addSubview(coverView)
        contentView.addSubview(downloadIcon)
        coverView.frame = contentView.frame
        downloadIcon.frame.size = CGSize(width: 60, height: 60)
        downloadIcon.center = contentView.center
        downloadIcon.contentMode = .scaleAspectFit
        downloadIcon.image("iCloudDownload")
        coverView.isHidden = true
        downloadIcon.isHidden = true
        coverView.addTapViewGesture(self, action: #selector(tapSingleDid))
        
    }
    
    ///是否显示下载图标和不能点击图片
    func setIsClickImage() {
        coverView.isHidden = !isICloud
        downloadIcon.isHidden = !isICloud
        imageView.isUserInteractionEnabled = !isICloud
    }
    
    //图片单击事件响应
    func tapSingleDid(_ ges:UITapGestureRecognizer){
        //显示或隐藏导航栏
        if let nav = self.responderViewControllerss()?.navigationController {
            nav.setNavigationBarHidden(!nav.isNavigationBarHidden, animated: true)
        }
    }
    
    //图片双击事件响应
    func tapDoubleDid(_ ges:UITapGestureRecognizer){
        //隐藏导航栏
        if let nav = self.responderViewControllerss()?.navigationController {
            nav.setNavigationBarHidden(true, animated: true)
        }
        //缩放视图（带有动画效果）
        UIView.animate(withDuration: 0.5, animations: {
            //如果当前不缩放，则放大到3倍。否则就还原
            if self.scrollView.zoomScale == 1.0 {
//                self.scrollView.zoomScale = 3.0
                //以点击的位置为中心，放大3倍
                let pointInView = ges.location(in: self.imageView)
                let newZoomScale:CGFloat = 3
                let scrollViewSize = self.scrollView.bounds.size
                let w = scrollViewSize.width / newZoomScale
                let h = scrollViewSize.height / newZoomScale
                let x = pointInView.x - (w / 2.0)
                let y = pointInView.y - (h / 2.0)
                let rectToZoomTo = CGRect(x:x, y:y, width:w, height:h)
                self.scrollView.zoom(to: rectToZoomTo, animated: true)
            } else {
                self.scrollView.zoomScale = 1.0
            }
        })
    }
    
    //查找所在的ViewController  ///返回view的vc
    func responderViewControllerss() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //视图布局改变时（横竖屏切换时cell尺寸也会变化）
    override func layoutSubviews() {
        super.layoutSubviews()
//        resetSize()
    }
    
    //重置单元格内元素尺寸
    func resetSize(){
        //scrollView重置，不缩放
        scrollView.frame = self.contentView.bounds
        scrollView.zoomScale = 1.0
        //imageView重置
        if let image = self.imageView.image {
            //设置imageView的尺寸确保一屏能显示的下
            imageView.frame.size = scaleSize(size: image.size)
            //imageView居中
            imageView.center = scrollView.center
        }
    }
    
//    获取imageView的缩放尺寸（确保首次显示是可以完整显示整张图片）
    func scaleSize(size:CGSize) -> CGSize {
        let width = size.width
        let height = size.height
        let widthRatio = width/UIScreen.main.bounds.width
        let heightRatio = height/UIScreen.main.bounds.height
        let ratio = max(heightRatio, widthRatio)
        return CGSize(width: width/ratio, height: height/ratio)
    }
    
}

//ImagePreviewCell的UIScrollViewDelegate代理实现
extension ZXPImagePreviewGridCell:UIScrollViewDelegate{
    
    //缩放视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    //缩放响应，设置imageView的中心位置
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : centerY
        print(centerX,centerY)
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}

extension ZXPImagePreviewGridCell {
    
    ///本地的图片
    func loadLocalImg(imagesAsset:PHAsset) {
        PHImageManager.default().requestImage(for: imagesAsset, targetSize: PHImageManagerMaximumSize , contentMode: . default, options: nil, resultHandler: { (image, info) in
            if (info!["PHImageResultIsInCloudKey"] as! Bool) && (image == nil) {
                PHImageManager.default().requestImage(for: imagesAsset, targetSize: self.calculateTargetSize(imagesAsset) , contentMode: .default, options: nil , resultHandler: { (image, info) in
                    self.isICloud = true
                    self.imageView.image = image
                    self.resetSize()
                })
            } else {
                self.isICloud = false
                self.imageView.image = image
                self.resetSize()
            }
        })
    }
    
    ///计算出小图大小 （ 为targetSize做准备 ）
    func calculateTargetSize(_ imagesAsset:PHAsset) -> CGSize {
        let ph = imagesAsset.pixelHeight / 10
        let pw = imagesAsset.pixelWidth / 10
        if ph > 300 {
            let q = ph - 250
            return CGSize(width: pw - q, height: 250)
        } else {
            return CGSize(width: pw , height: ph )
        }
    }
}
