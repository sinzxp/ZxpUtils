//
//  ZXPImagePickerController.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/1/11.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

var KSCREEN_HEIGHT =  UIScreen.main.bounds.size.height
var KSCREEN_WIDTH =  UIScreen.main.bounds.size.width

public class ZXPImagePickerController: UIViewController , PHPhotoLibraryChangeObserver {

    var myCollectionView: UICollectionView!
    //  collectionView 布局
    let flowLayout = UICollectionViewFlowLayout()
    //  collectionviewcell 复用标识
    let reuseIdentifier = "myCell"
    //  数据源
    var photosArray = PHFetchResult<PHAsset>()
    //  已选图片数组，数据类型是 PHAsset
    var seletedPhotosArray = [PHAsset]()
    //  每个图片设置一个初始标识
    var divideArray:[Int] = []
    
    
    ///  MARK:- 获取全部图片
    private func getAllPhotos() {
        //  注意点！！-这里必须注册通知，不然第一次运行程序时获取不到图片，以后运行会正常显示。体验方式：每次运行项目时修改一下 Bundle Identifier，就可以看到效果。
        PHPhotoLibrary.shared().register(self)
        //  获取所有系统图片信息集合体
        let allOptions = PHFetchOptions()
        //  对内部元素排序，按照时间由远到近排序
        allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        //  将元素集合拆解开，此时 allResults 内部是一个个的PHAsset单元
        let allResults = PHAsset.fetchAssets(with: allOptions)
        photosArray = allResults
        //  每个图片设置一个初始标识
        for _ in 0 ..< allResults.count {
            divideArray.append(0)
        }
    }
    //  PHPhotoLibraryChangeObserver  第一次获取相册信息，这个方法只会进入一次
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        getAllPhotos()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        getAllPhotos()
        
        createCollectionView()
        
        let indexPath = IndexPath(item: photosArray.count - 1, section: 0)
        myCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)

    }



}

extension ZXPImagePickerController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func createCollectionView() {
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 5
        let cellWidth: CGFloat = (KSCREEN_WIDTH - 5 * shape) / 4
        flowLayout.sectionInset = UIEdgeInsetsMake(0, shape, 0, shape)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        myCollectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT) , collectionViewLayout: flowLayout)
        myCollectionView.backgroundColor = .white
        //  添加协议方法
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(myCollectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        cell.isChoose = divideArray[indexPath.row] == 0 ? false : true
        //  展示图片
        PHCachingImageManager.default().requestImage(for: photosArray[indexPath.row], targetSize: CGSize.zero, contentMode: .aspectFit, options: nil) { (result: UIImage?, dictionry: Dictionary?) in
            cell.imageView.image = result ?? UIImage.init(named: "iw_none")
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        currentCell.isChoose = !currentCell.isChoose
        divideArray[indexPath.row] = divideArray[indexPath.row] == 0 ? 1 : 0
    }
    
//    //  MARK:- 展示和点击完成按钮
//    func completedButtonShow() {
//        var originY: CGFloat
//        
//        if seletedPhotosArray.count > 0 {
//            originY = KSCREEN_HEIGHT - 44
//            flowLayout.sectionInset.bottom = 44
//        } else {
//            originY = KSCREEN_HEIGHT
//            flowLayout.sectionInset.bottom = 0
//        }
//        
//        UIView.animateWithDuration(0.2) {
//            self.completedButton.frame.origin.y = originY
//            self.countLable.text = String(self.seletedPhotosArray.count)
//            
//            //  仿射变换
//            UIView.animateWithDuration(0.2, animations: {
//                self.countLable.transform = CGAffineTransformMakeScale(0.35, 0.35)
//                self.countLable.transform = CGAffineTransformScale(self.countLable.transform, 3, 3)
//            })
//        }
//    }
    
}

class MyCollectionViewCell: UICollectionViewCell {
    
    let selectButton = UIButton()
    let imageView = UIImageView()
    //  cell 是否被选择
    var isChoose = false {
        didSet {
            selectButton.isSelected = isChoose
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  展示图片
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.backgroundColor = .cyan
        
        //  展示图片选择图标
        selectButton.frame = CGRect(x: contentView.bounds.size.width * 3 / 4 - 2, y: 2, width: contentView.bounds.size.width / 4, height: contentView.bounds.size.width / 4)
        selectButton.setBackgroundImage(UIImage.init(named: "favorite"), for: .normal)
        selectButton.setBackgroundImage(UIImage.init(named: "favorite_select"), for: .selected)
        imageView.addSubview(selectButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }  
}
