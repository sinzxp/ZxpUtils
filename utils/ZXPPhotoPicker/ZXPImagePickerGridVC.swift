//
//  ZXPImagePickerGridVCViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/3.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

//PHAsset和PHAsset状态
struct PHAssetItem {
    var isInCloud = false
    var isHDImage = false
    var result:PHAsset!
}

class ZXPImagePickerGridVC: ZXPImagePickerVC {
    
    var completeHandlerPHA:((_ assets:[PHAsset])->())?
    var completeHandlerIMG:((_ images:[UIImage])->())?
    var maxSelected:Int = 9
    
    var myCollectionView: UICollectionView!
    //  collectionView 布局
    let flowLayout = UICollectionViewFlowLayout()
    //  collectionviewcell 复用标识
    let reuseIdentifier = "myCell"
    
    ///取得的资源结果，用了存放的PHAsset
    var fetchResult:PHFetchResult<PHAsset>!
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    ///缩略图大小
    var thumbnailSize:CGSize!
    ///选择的cell
    var selectedItems:[IndexPath] = []
    
    let opt = PHImageRequestOptions()
    
    var islocalImgs:[Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = fetchResult {
            
        } else {
            self.title = "照片库"
            getCollection()
        }
        
        let rightBarItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ZXPImagePickerGridVC.cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.view.backgroundColor = UIColor.white
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager() //new一个即可
        self.resetCachedAssets()
        
        ///设置 CollectionView
        createCollectionView()
        calculateThumbnailSize()

        ///不修改图片加了没用
//        PHPhotoLibrary.shared().register(self)
        
        setTabbar()
    }
    
    ///重置缓存
    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
    }

    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 如果fetchResult为空 获取所有图片
    func getCollection() {
        // 获取所有系统图片信息集合体
        let smartOptions = PHFetchOptions()
        //  对内部元素排序，按照时间由远到近排序
        smartOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        //  将元素集合拆解开，此时 allResults 内部是一个个的PHAsset单元
        let allResults = PHAsset.fetchAssets(with: .image, options: smartOptions)
        fetchResult = allResults
    }
    
    /// 计算出小图大小 （ 为targetSize做准备 ）
    func calculateThumbnailSize() {
        let scale = UIScreen.main.scale //像素?
        let cellSize = flowLayout.itemSize
        thumbnailSize = CGSize( width: cellSize.width * scale , height: cellSize.height * scale)
    }
    
    //类反初始化方法（析构方法）在销毁前?
    deinit {
        self.resetCachedAssets()
        //可以做一些清理工作
        print("销毁ZXPImagePickerGridVC")
//        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    let tabBg = UIView()
    let browse = UILabel()
    let complete = UILabel()
    let imgNumber = UILabel()
    
    ///设置预览完成按钮
    public func setTabbar() {
        self.view.addSubview(tabBg)
        self.tabBg.addSubview(browse)
        self.tabBg.addSubview(complete)
        self.view.addSubview(imgNumber)
        
        tabBg.backgroundColor = UIColor(fromHexCode: "#eaeaea")
        
        browse.text = "预览"
        browse.textColor = UIColor.blue
        browse.textAlignment = .center
        
        complete.text = "完成"
        complete.textColor = UIColor.blue
        complete.textAlignment = .center
        
        imgNumber.text = "0"
        imgNumber.textColor = UIColor.white
        imgNumber.textAlignment = .center
        imgNumber.backgroundColor = UIColor.orange
        
        tabBg.frame = CGRect(x: 0, y: ZSCREEN_HEIGHT - 44, width: ZSCREEN_WIDTH , height: 44)
        browse.frame = CGRect(x: 0, y: 0 , width: 70 , height: 44)
        complete.frame = CGRect(x: ZSCREEN_WIDTH - 70, y: 0 , width: 70 , height: 44)
        imgNumber.frame.size = CGSize(width: 26, height: 26)
        imgNumber.frame.origin = CGPoint(x: ZSCREEN_WIDTH - 67, y: tabBg.frame.minY - 5)
        imgNumber.layer.cornerRadius = 13
        imgNumber.layer.masksToBounds = true
        
        let line = UIView()
        self.tabBg.addSubview(line)
        line.backgroundColor = UIColor.lightGray
        line.frame = CGRect(x: 0, y: 0 , width: ZSCREEN_WIDTH , height: 1)
        
        browse.addTapViewGesture(self, action: #selector(toImagePreview))
        complete.addTapViewGesture(self, action: #selector(selectedComplete))

        setTabLabel()
    }
    
    ///预览
    func toImagePreview() {
        let ss = screeningSelectPHAsset()
        if !ss.isEmpty {
            let vc = ZXPImagePreviewVC()
            vc.images = ss
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    ///右下角选择数动画
    func imgNumberAnimate() {
        setTabLabel()
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.imgNumber.layer.setAffineTransform(CGAffineTransform(scaleX: 0.2,y: 0.2))
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5, animations: {
                self.imgNumber.layer.setAffineTransform(CGAffineTransform.identity)
            })
        }){ bool in
            
        }
    }
    
    ///获取已选择个数
    func selectedCount() -> Int {
//        return self.myCollectionView.indexPathsForSelectedItems?.count ?? 0
        return selectedItems.count
    }
    
    ///设置右下角选择数显示效果
    func setTabLabel() {
        let count = selectedCount()
        self.imgNumber.text = "\(count)"
        if count > 0 {
            browse.textColor = UIColor.blue
            complete.textColor = UIColor.blue
            imgNumber.isHidden = false
        } else {
            browse.textColor = UIColor.lightGray
            complete.textColor = UIColor.lightGray
            imgNumber.isHidden = true
        }
    }
    
    func selectedComplete() {
        if selectedItems.isEmpty {
            return
        }
        if let _ = completeHandlerIMG {
            completeSelectUIImage()
        }
        if let _ = completeHandlerPHA {
            completeSelectPHAsset()
        }
        
    }
    
    ///返回选择的PHAsset数组
    func screeningSelectPHAsset() -> [PHAsset] {
        var phas:[PHAsset] = []
        for item in selectedItems {
            phas.append(fetchResult[item.row])
        }
        return phas
    }
    
    func completeSelectPHAsset() {
        completeHandlerPHA?(screeningSelectPHAsset())
        self.dismiss(animated: true, completion: nil)
    }
    
    ///返回选择的UIImage数组
    func completeSelectUIImage() {
//        let alertController = UIAlertController(title: "(～￣▽￣)～",  message: "\n获取图片中.....", preferredStyle: .alert)
//        self.present(alertController, animated: true, completion: nil)
        var imgs:[UIImage] = []
        let optg = PHImageRequestOptions()
        optg.isSynchronous = true ///同步 主线程
        optg.isNetworkAccessAllowed = true ///从iCloud上下载原图
        var errorTag = false
        for item in screeningSelectPHAsset() {
            PHImageManager.default().requestImage(for: item, targetSize: PHImageManagerMaximumSize , contentMode: .default, options: optg, resultHandler: { (image, info) in
                if image == nil {
                    errorTag = true
                } else {
                    imgs.append(image!)
                }
            })
            if errorTag {
                break
            }
        }
        if errorTag {
//            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.showActionAlert("提示", message: "获取图片失败")
            return
        }
//        self.presentedViewController?.dismiss(animated: false, completion: nil)
        print("乘车--- \(imgs)")
        completeHandlerIMG?(imgs)
        self.dismiss(animated: true, completion: nil)
     }
    
}

extension ZXPImagePickerGridVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func createCollectionView() {
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 1
        let cellWidth: CGFloat = (ZSCREEN_WIDTH - 5 * shape) / 4
        flowLayout.sectionInset = UIEdgeInsetsMake(shape, 0, shape, 0)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        myCollectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: ZSCREEN_WIDTH, height: ZSCREEN_HEIGHT - 44) , collectionViewLayout: flowLayout)
        myCollectionView.backgroundColor = .white
        // 设置允许多选
        myCollectionView.allowsMultipleSelection = true
        // 添加协议方法
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
//        myCollectionView.decelerationRate = 1
        myCollectionView.register(ZXPImagePickerGridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(myCollectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ZXPImagePickerGridCell
        cell.isCloudImg()
        opt.deliveryMode = .fastFormat
        opt.resizeMode = .fast
        ///  展示图片 获取缩略图
        let img = self.fetchResult[indexPath.row]
        self.imageManager.requestImage(for: img, targetSize: self.thumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (result, dictionry) in
            cell.imageView.image = result
        }
        /// 判断在不在本地
        self.imageManager.requestImage(for: self.fetchResult[indexPath.row], targetSize: PHImageManagerMaximumSize , contentMode: . default, options: opt, resultHandler: { (_, info) in
            print(info)
            let ickey = info!["PHImageResultIsInCloudKey"]
            if (ickey as? Bool) {
                cell.isCloudImg()
            } else {
                cell.islocalImg()
            }
        })
        return cell
    }
    
    ///选择时执行 点击图片
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ZXPImagePickerGridCell
        if !cell.coverView.isHidden {
            collectionView.deselectItem(at: indexPath, animated: false)
            self.loadOriginalImg(fetchResult[indexPath.row], cell: cell)
        } else {
            if selectedCount() < maxSelected {
                selectedItems.append(indexPath)
                imgNumberAnimate()
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
                self.showActionTime(title: "已超出数量限制")
            }
        }
    }
    
    ///取消选择时执行
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = selectedItems.index(of: indexPath) {
            selectedItems.remove(at: index)
        }
        imgNumberAnimate()
    }
    
    //collectionView里某个cell将要显示时
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
    //collectionView里某个cell显示完毕时
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
}

//监听资源改变 PHPhotoLibraryChangeObserver代理实现，图片新增、删除、修改开始后会触发
//extension ZXPImagePickerGridVC:PHPhotoLibraryChangeObserver{
//
//    //当照片库发生变化的时候会触发
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
////        getCollection()
//    }
//
//}

