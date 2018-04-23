//
//  ViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/1/11.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import CJWUtilsS

class ViewController: UIViewController {
    
    let img = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        
        view.addSubview(img)
        img.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        img.backgroundColor = UIColor.blue
        
        img.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        img.addGestureRecognizer(tapGR)
        img.tag = 99
        
        let img1 = UIImageView()
        view.addSubview(img1)
        img1.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
        img1.backgroundColor = UIColor.yellow
        
        img1.isUserInteractionEnabled = true
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(imagePicker1))
        img1.addGestureRecognizer(tapGR1)
        
    }
    
    func imagePicker1() {
//        let picker = ZXPImagePickerController()
//        self.pushViewController(picker)
        let image = UIImage(named: "favorite_select")
        let data:Data = UIImagePNGRepresentation(image!)!
        DownloadAndFile.share.saveImageToDocument(data, name: "favorite_select", suffixType: .png)
    }
    
    func tapHandler(sender:UITapGestureRecognizer) {
        
        DownloadAndFile.share.contentsOfURL()
        if let img = DownloadAndFile.share.readFileForImage("favorite_select.png") {
            self.img.image = img
        } else {
            self.showText("失败")
        }
        
//        let pickerVc = ZLPhotoPickerViewController()
//        pickerVc.status = .savePhotos
//        pickerVc.isShowCamera = false
//        pickerVc.photoStatus = .photos
//       pickerVc.showPickerVc(self)
        
//        self.pickImage(3,editAble: false) { (images) in
//            let img = images[0]
//            self.img.image = img
//        }
        
//        self.imagePicker { (image) in
//            print("++--*----->\(String(describing: sender.view?.tag))")
//            self.img.image = image
//        }

    }

}

