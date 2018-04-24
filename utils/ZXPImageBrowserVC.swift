//
//  ZXPImageBrowserVC.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/4/24.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPImageBrowserVC: UIViewController {
    
    var images:[UIImage] = []
    
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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

extension ZXPImageBrowserVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        collectionView.register(ZXPImageBrowserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ZXPImageBrowserCell
        let img = images[indexPath.row]
        cell.imageView.image = img
        return cell
    }
    
    //collectionView单元格尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    //collectionView里某个cell将要显示时
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ZXPImageBrowserCell {
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
    
}

class ZXPImageBrowserCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    var scrollView:UIScrollView!
    
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
        scrollView.addSubview(imageView)
        
        contentView.backgroundColor = UIColor.clear
        
        self.imageView.addTapDoubleGesture(target: self, tapSingleDid: #selector(tapSingleDid), tapDoubleDid: #selector(tapDoubleDid))
        
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
    
    func responderViewControllerss() -> UIViewController? {
        return self.viewController()
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

extension ZXPImageBrowserCell:UIScrollViewDelegate{
    
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
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}

