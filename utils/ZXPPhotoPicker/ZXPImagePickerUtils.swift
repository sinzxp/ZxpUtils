//
//  ZXPImagePickerUtils.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/4/18.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

//MARK: - 图片浏览器
extension UIViewController {
    
    ///图片浏览器 返回[UIImage]
    func presentImagePicker(maxSelected:Int,handler:@escaping (_ images:[UIImage])->()) {
        guard ZXPPermissionsUtils.isPhotoLibraryPermissions() else {
            return
        }
        let vc = ZXPImagePickerTableVC()
        vc.completeHandlerIMG = handler
        vc.maxSelected = maxSelected
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    ///图片浏览器 返回[PHAsset]
    func presentAssetsPicker(maxSelected:Int,handler:@escaping (_ assets:[PHAsset])->()) {
        guard ZXPPermissionsUtils.isPhotoLibraryPermissions() else {
            return
        }
        let vc = ZXPImagePickerTableVC()
        vc.completeHandlerPHA = handler
        vc.maxSelected = maxSelected
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}


//MARK: - 保存图片到相册 自定义相册名
class PhotoAlbumUtil {
    
    //操作结果枚举
    enum PhotoAlbumUtilResult {
        case success, error
    }
    
    ///保存图片到相册  要读取和写入权限
    ///主线程会卡
    class func SaveImageInAlbum(image: UIImage, albumName: String = "", completion: ((_ result: PhotoAlbumUtilResult) -> ())?) {
        
        //权限验证
        guard ZXPPermissionsUtils.isPhotoLibraryPermissions() else {
            return
        }
        
        var assetAlbum: PHAssetCollection?
        
        //如果指定的相册名称为空，则保存到相机胶卷。（否则保存到指定相册）
        if albumName.isEmpty {
            let list = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary,options: nil)
            assetAlbum = list[0]
        } else {
            //看保存的指定相册是否存在
            let list = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            list.enumerateObjects({ (album, index, stop) in
                let assetCollection = album
                if albumName == assetCollection.localizedTitle {
                    assetAlbum = assetCollection
                    stop.initialize(to: true)
                }
            })
            //不存在的话则创建该相册
            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (isSuccess, error) in
                    self.SaveImageInAlbum(image: image, albumName: albumName,completion: completion) //再来一次
                })
                return
            }
        }
        
        //保存图片
        PHPhotoLibrary.shared().performChanges({
            //添加的相机胶卷
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image) ///完成添加
            //是否要添加到相簿
            if !albumName.isEmpty {
                let assetPlaceholder = result.placeholderForCreatedAsset
                let albumChangeRequset = PHAssetCollectionChangeRequest(for:assetAlbum!)
                albumChangeRequset!.addAssets([assetPlaceholder!] as NSArray)
            }
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                completion?(.success)
            } else{
                print(error!.localizedDescription)
                completion?(.error)
            }
        }
    }
    
    ///PHAsset 图片资源本地地址 支线程
    class func PHAssetUrl(_ asset:PHAsset,handler:@escaping (_ result: URL?) -> ()){
        //通过标志符获取对应的资源 .localIdentifier
        //        let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [self.localId], options: nil)
        //        let asset = assetResult[0]
        let options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in return true }
        //图片路径
        asset.requestContentEditingInput(with: options, completionHandler: {
            (contentEditingInput:PHContentEditingInput?, info: [AnyHashable : Any]) in
            let url = contentEditingInput?.fullSizeImageURL
            handler(url)
        })
    }
    
}
