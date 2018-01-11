//
//  ViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/1/11.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

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
        
    }
    
    func tapHandler(sender:UITapGestureRecognizer) {
        
        self.imagePicker { (image) in
            print("++--*----->\(String(describing: sender.view?.tag))")
            self.img.image = image
        }

    }

    func imagePicker(block:@escaping ImagePickerBlock) {
        let picker = ZXPAppleImagePickerController()
        picker.pickerImage(vc: self,block: block)
    }

}

