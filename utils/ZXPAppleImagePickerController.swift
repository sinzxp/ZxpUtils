//
//  ZXPAppleImagePickerController.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/1/11.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
// 使用相机设备（AVCaptureDevice）功能时
import Photos
// 使用图片库功能
import AssetsLibrary
// 使用录制视频功能
import MobileCoreServices

///获取相册图片和拍照并保存图片  ps:录像功能还没加
public class ZXPAppleImagePickerController: UIImagePickerController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private var block: ImagePickerBlock!
    ///使用相机时或maxSelected=1时
    var isEditor = false
    ///使用相机时 保存图片
    var isSavedPhoto = false
    
    typealias ImagePickerBlock = ((_ images:[UIImage])->())
    private var maxSelected:Int = 9 ///1是使用系统相册
    
    ///选择照片的方法
    func pickerImage(vc viewController:UIViewController,maxSelected:Int,block:@escaping ImagePickerBlock) {
        
        let alertController = UIAlertController(title: "请选择", message: "",
                                                preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "相机", style: .default){action in self.pickerCamera(viewController)}
        let photoLibraryAction = UIAlertAction(title: "图库", style: .default){action in self.pickerPhotoLibrary(viewController)}
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        self.block = block
        self.maxSelected = maxSelected
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    ///相册
    private func pickerPhotoLibrary(_ vc:UIViewController) {
        if isPhotoLibrary() {
            if maxSelected > 1 {
                self.zxpPhotoLibrary(vc)
            } else {
                self.photoLibrary(vc)
            }
        }else{
            vc.showActionAlert("图库不可用", message: "")
        }
    }
    ///相机
    private func pickerCamera(_ vc:UIViewController) {
        if isCamera() {
            if vc.isCameraPermissions() {
                self.camera(vc)
            }
        } else {
            vc.showActionAlert("相机不可用", message: "")
        }
    }
    
    private func zxpPhotoLibrary(_ vc:UIViewController) {
        vc.presentImagePicker(maxSelected: maxSelected, handler: block)
    }
    
    private func photoLibrary(_ vc:UIViewController) {
        self.sourceType = UIImagePickerControllerSourceType.photoLibrary
//          self.mediaTypes = UIImagePickerController.availableMediaTypes(for: self.sourceType)!
        ///可编辑
        self.allowsEditing = isEditor
        self.delegate = self
        vc.present(self, animated: true, completion: nil)
    }
    
    private func camera(_ vc:UIViewController) {
        self.sourceType = UIImagePickerControllerSourceType.camera
        // 相机模式下支持的媒体类型 显示那些类型
//        self.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)! //支持的全部
//        self.mediaTypes = [kUTTypeMovie as String] //自己加
        self.allowsEditing = isEditor
        self.delegate = self
//        self.cameraDevice = .front //前摄
//        self.cameraFlashMode = .on //闪光灯
        vc.present(self, animated: true, completion: nil)
    }
    
    //选择好照片后choose后执行的方法 选取的信息都在info中，info 是一个字典
    /*
     指定用户选择的媒体类型 UIImagePickerControllerMediaType
     原始图片 UIImagePickerControllerOriginalImage
     修改后的图片 UIImagePickerControllerEditedImage
     裁剪尺寸 UIImagePickerControllerCropRect
     媒体的URL UIImagePickerControllerMediaURL
     原件的URL UIImagePickerControllerReferenceURL
     当来数据来源是照相机的时候这个值才有效 UIImagePickerControllerMediaMetadata
     */
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("图片选择：\(info)")
        if isEditor {
            //获取编辑后的图片
            let image = info[UIImagePickerControllerEditedImage] as? UIImage
            toBlock(img: image,picker:picker)
        } else {
            //获取选择的原图
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            toBlock(img: image,picker:picker)
        }
    }
    
    func toBlock(img:UIImage?,picker: UIImagePickerController) {
        if let image = img {
            block([image])
            // 图片保存到相册 拍照模式下
            if (picker.sourceType == .camera) && isSavedPhoto {
                savedPhoto(image)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    
    ///cancel后执行的方法
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        ///关闭窗口
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension NSObject{
    
    ///保存图片
    func savedPhoto(_ image:UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    //保存图片的回调
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            print("保存失败")
            return
        }
        print("OK")
    }
    
    ///相机可不可以用
    func isCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    ///相相册可不可以用
    func isPhotoLibrary() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    //前置摄像头可不可以用
    func isCameraFront() -> Bool {
        ///判断 isCameraDeviceAvailable
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front)
    }
    
    ///判断相机权限
    func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if (authStatus == .denied || authStatus == .restricted) {
            return false
        }else {
            return true
        }
    }
    
    ///判断相册权限
    func PhotoLibraryPermissions() -> Bool {
        let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if (library == .denied || library == .restricted) {
            return false
        }else {
            return true
        }
    }
    
}


public class ZXPAppleVideoController: UIImagePickerController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: 摄像
    func videoShow(_ vc:UIViewController) {
        /*
         使用如下属性时，注意添加framework：MobileCoreServices
         
         KUTTypeImage 包含
         const CFStringRef  kUTTypeImage ;抽象的图片类型
         const CFStringRef  kUTTypeJPEG ;
         const CFStringRef  kUTTypeJPEG2000 ;
         const CFStringRef  kUTTypeTIFF ;
         const CFStringRef  kUTTypePICT ;
         const CFStringRef  kUTTypeGIF ;
         const CFStringRef  kUTTypePNG ;
         const CFStringRef  kUTTypeQuickTimeImage ;
         const CFStringRef  kUTTypeAppleICNS
         const CFStringRef  kUTTypeBMP;
         const CFStringRef  kUTTypeICO;
         
         KUTTypeMovie 包含：
         const CFStringRef  kUTTypeAudiovisualContent ;抽象的声音视频
         const CFStringRef  kUTTypeMovie ;抽象的媒体格式（声音和视频）
         const CFStringRef  kUTTypeVideo ;只有视频没有声音
         const CFStringRef  kUTTypeAudio ;只有声音没有视频
         const CFStringRef  kUTTypeQuickTimeMovie ;
         const CFStringRef  kUTTypeMPEG ;
         const CFStringRef  kUTTypeMPEG4 ;
         const CFStringRef  kUTTypeMP3 ;
         const CFStringRef  kUTTypeMPEG4Audio ;
         const CFStringRef  kUTTypeAppleProtectedMPEG4Audio;
         */
        
        // 获得相机模式下支持的媒体类型
        if !isCamera() {
            vc.showActionAlert("相机不可用", message: "")
            return
        }
        let availableMediaTypes:Array = UIImagePickerController.availableMediaTypes(for: .camera)!
        var canTakeVideo = false
        for mediaType in availableMediaTypes {
            if mediaType == (kUTTypeImage as String) {
                // 支持摄像
                canTakeVideo = true
                break;
            }
        }
        // 检查是否支持摄像
        if (!canTakeVideo) {
            print("sorry, capturing video is not supported.!!!")
            return
        }
        
        // 创建图像选取控制器
//        let videoPicker = UIImagePickerController()
        // 设置图像选取控制器的来源模式为相机模式
        self.sourceType = UIImagePickerControllerSourceType.camera
        // 设置图像选取控制器的类型为动态图像，即视频文件
        self.mediaTypes = [kUTTypeMovie as String]
        // 设置摄像图像品质
        self.videoQuality = UIImagePickerControllerQualityType.typeHigh
        // 设置最长摄像时间
        self.videoMaximumDuration = 8
        // 允许用户进行编辑
        self.allowsEditing = false
        // 设置委托对象
        self.delegate = self
        // 以模式视图控制器的形式显示
        vc.present(self, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("图片选择：\(info)")
        // 获取媒体类型
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        // 判断是静态图像还是视频
        if mediaType == (kUTTypeImage as String) {
            
        } else if mediaType == (kUTTypeMovie as String) {
            // 获取视频文件的url
            let mediaURL = info[UIImagePickerControllerMediaURL] as! URL
            // 视频文件的地址
            let pathString = mediaURL.relativePath
            print("视频地址：\(pathString)")
            // 创建PHPhotoLibrary对象并将视频保存到媒体库（注意添加frame：AssetsLibrary）
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathString) {
                UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
                print("保存成功")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //保存回调
    override func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            print("保存失败")
            return
        }
        print("OK")
    }
    
    ///cancel后执行的方法
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
}


