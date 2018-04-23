//
//  ZXPImagePreviewVC.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/4.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

class ZXPImagePreviewVC:ZXPImagePickerVC {
    
    var images:[PHAsset] = []
        
    var collectionView: UICollectionView!
    //  collectionView 布局
    let flowLayout = UICollectionViewFlowLayout()
    //  collectionviewcell 复用标识
    let reuseIdentifier = "imgCell"
    //默认显示的图片索引
    var index:Int = 0
    //页控制器（小圆点）
    var pageControl : UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "照片库"
        createCollectionView()
        setPageControl()
        self.collectionView.reloadData()
    }
    
    //视图显示时
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏导航栏
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //视图消失时
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    ///加载原图
    func loadOriginalImg2(_ asset:PHAsset , cell:ZXPImagePreviewGridCell) {
        showProgressView()
        let opt = PHImageRequestOptions()
        opt.isSynchronous = false
        opt.isNetworkAccessAllowed = true
        opt.progressHandler = progress
        imageRequestID = PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize , contentMode: . default, options: opt, resultHandler: { (image, info) in
            let ss = info!["PHImageCancelledKey"] as? Int
            if ss == 1 || image == nil {
                print("下载失败")
            } else {
                cell.imageView.image = image
                cell.isICloud = false
            }
            self.imageRequestID = nil
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        })
    }
    
    ///页控制器
    func setPageControl() {
        //将视图滚动到默认图片上
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //设置页控制器
        pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor.lightGray
        pageControl.center = CGPoint(x: view.frame.width / 2, y: view.frame.height - 20)
        pageControl.numberOfPages = images.count
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = index
        view.addSubview(self.pageControl)
        setNagTitle(index)
    }
    
    func setNagTitle(_ index:Int) {
        self.title = "\(index + 1)/\(images.count)"
    }
    
}

extension ZXPImagePreviewVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func createCollectionView() {
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //横向滚动
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame:view.frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.black
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        // 添加协议方法
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ZXPImagePreviewGridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //不自动调整内边距，确保全屏
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ZXPImagePreviewGridCell
        let img = images[indexPath.row]
        cell.loadLocalImg(imagesAsset: img)
        cell.downloadIcon.tag = indexPath.row
        cell.downloadIcon.addTapViewGesture(self, action: #selector(toLoadOriginalImg))
        return cell
    }
    
    //collectionView单元格尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    //collectionView里某个cell将要显示时
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ZXPImagePreviewGridCell {
            //由于单元格是复用的，所以要重置内部元素尺寸
            cell.resetSize()
        }
    }
    
    //collectionView里某个cell显示完毕时
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //当前显示的单元格
        let visibleCell = collectionView.visibleCells[0] ///可见的cell
        //设置页控制器当前页
        let index = collectionView.indexPath(for: visibleCell)!.item
        self.pageControl.currentPage = index
        setNagTitle(index)
    }
    
    
    func toLoadOriginalImg(_ ges:UITapGestureRecognizer) {
        let tag = ges.view!.tag
        let indexPath:IndexPath = [0,tag]
        let cell = collectionView.cellForItem(at: indexPath) as! ZXPImagePreviewGridCell
        self.loadOriginalImg2(images[tag], cell: cell)
    }
}
