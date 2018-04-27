//
//  ZXPImagePickerGridCell.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/3.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos
import CJWUtilsS

class ZXPImagePickerGridCell: UICollectionViewCell {
        
    let selectButton = UIButton()
    let imageView = UIImageView()
    let downloadIcon = UIImageView()
    let coverView = UIView()
    var progressText = UILabel()
    
    //  cell 是否被选择 重写 自动调用
    open override var isSelected: Bool {
        didSet{
            selectButton.isSelected = isSelected
        }
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
    }
    
    public func setup() {
        //  展示图片
        imageView.frame = contentView.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        contentView.addSubview(imageView)
        
        //  展示图片选择图标
        selectButton.frame = CGRect(x: contentView.bounds.size.width * 3 / 4 - 5, y: 5, width: contentView.bounds.size.width / 4, height: contentView.bounds.size.width / 4)
        selectButton.setBackgroundImage(UIImage.init(named: "zxp_pp_icon_image_no"), for: .normal)
        selectButton.setBackgroundImage(UIImage.init(named: "zxp_pp_icon_image_yes"), for: .selected)
        contentView.addSubview(selectButton)
        selectButton.isHidden = true
        
        contentView.addSubview(coverView)
        coverView.frame = contentView.frame
        coverView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        coverView.addSubview(downloadIcon)
        downloadIcon.frame = selectButton.frame
        downloadIcon.image("iCloudDownload")
        downloadIcon.contentMode = .scaleAspectFit
        coverView.isHidden = true
        
        contentView.addSubview(progressText)
        progressText.frame = contentView.frame
        progressText.text = "0%"
        progressText.textAlignment = .center
        progressText.textColor = UIColor.black
        progressText.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        progressText.isHidden = true
        
        progressText.addTapViewGesture(self, action: #selector(hhhh)) 
    }
    
    func hhhh() {
        print("为加载完不给选中")
    }
    
    ///本地
    func islocalImg() {
        selectButton.isHidden = false
        coverView.isHidden = true
        progressText.isHidden = true
    }
    ///正在下载
    func isLoadingImg() {
        selectButton.isHidden = true
        coverView.isHidden = true
        progressText.isHidden = false
    }
    ///在clocd
    func isCloudImg() {
        selectButton.isHidden = true
        coverView.isHidden = false
        progressText.isHidden = true
    }
    
//    ///加载原图
//    func loadOriginalImg(result:PHAsset,balck:@escaping (_ indexPath:IndexPath ) -> ()) {
//        self.isLoadingImg()
//        let opt = PHImageRequestOptions()
//        opt.isNetworkAccessAllowed = true
//        opt.progressHandler = progress
//        PHImageManager.default().requestImage(for: result, targetSize: PHImageManagerMaximumSize , contentMode: . default, options: opt, resultHandler: { (image, info) in
//            self.islocalImg()
//            balck(self.indexPath)
//        })
//    }
//    
//    func progress(progress:Double, error:Error?, stop:UnsafeMutablePointer<ObjCBool>, info:[AnyHashable : Any]?) {
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.progressText.text = "\(Int(progress * 100)) %"
//        })
//        print("\(progress * 100) %")
//    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}
