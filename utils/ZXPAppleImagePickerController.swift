//
//  ZXPAppleImagePickerController.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/1/11.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

typealias ImagePickerBlock = (_ image:UIImage) -> ()

public class ZXPAppleImagePickerController: UIImagePickerController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var block: ImagePickerBlock!
    
    ///选择照片的方法
    func pickerImage(vc viewController:UIViewController,block:@escaping ImagePickerBlock) {
        
        let alertController = UIAlertController(title: "请选择", message: "",
                                                preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "相机", style: .default){action in self.pickerCamera(viewController)}
        let photoLibraryAction = UIAlertAction(title: "图库", style: .default){action in self.pickerPhotoLibrary(viewController)}
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        self.block = block
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    ///相册
    func pickerPhotoLibrary(_ vc:UIViewController) {
        if isPhotoLibrary() {
            self.photoLibrary(vc)
        }else{
            //                vc.showPrompt("图库不可用")
        }
    }
    ///相机
    func pickerCamera(_ vc:UIViewController) {
        if isCamera() {
            self.camera(vc)
        }else{
            //                vc.showPrompt("相机不可用")
        }
    }
    
    func photoLibrary(_ vc:UIViewController) {
        
        self.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.mediaTypes = UIImagePickerController.availableMediaTypes(for: self.sourceType)!
        ///可编辑
        self.allowsEditing = true
        self.delegate = self
        vc.present(self, animated: true, completion: nil)
        
    }
    
    func camera(_ vc:UIViewController) {
        self.sourceType = UIImagePickerControllerSourceType.camera
        self.mediaTypes = UIImagePickerController.availableMediaTypes(for: self.sourceType)!
        self.allowsEditing = true
        self.delegate = self
        vc.present(self, animated: true, completion: nil)
    }
    
    //选择好照片后choose后执行的方法 选取的信息都在info中，info 是一个字典
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        //获取编辑后的图片
        //      let image = info[UIImagePickerControllerEditedImage] as! UIImage
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = image {
            block(image)
        }
        
    }
    
    ///cancel后执行的方法
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        ///关闭窗口
        self.dismiss(animated: true, completion: nil)
    }
}

extension NSObject{
    
    //相机可不可以用
    func isCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    //相相册可不可以用
    func isPhotoLibrary() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func QHLog(prompt:AnyObject) {
        NSLog("\(classForCoder)---->\(prompt)")
    }
    
}

