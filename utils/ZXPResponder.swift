//
//  ZXPResponder.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/28.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

class ZXPResponder :  UIResponder, UIApplicationDelegate {
    
    //监听相册变化时用到
    public var assetsFetchResults:PHFetchResult<PHAsset>?
    
}

//MARK: 监听相册变化获取新添加的图片 PHPhotoLibraryChangeObserver代理实现，图片新增、删除、修改开始后会触发
extension ZXPResponder : PHPhotoLibraryChangeObserver {
    
    ///获取最新添加的图片
    open func getNewAddedImage(_ thumbnail:UIImage?,asset: PHAsset) {
        
    }
    
    ///监听相册变化
    public func addPhPhotoLibraryRegister() {
        if PhotoLibraryPermissions() {
            self.getAssetsFetchResults()
            PHPhotoLibrary.shared().register(self)
        }
    }
    
    ///删除监听相册变化
    public func removePhPPhotoLibraryRegister() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    //当照片库发生变化的时候会触发
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        if let assetsFetchResults = self.assetsFetchResults {
            //获取assetsFetchResults的所有变化情况，以及assetsFetchResults的成员变化前后的数据
            guard let collectionChanges = changeInstance.changeDetails(for: self.assetsFetchResults as! PHFetchResult<PHObject>) else { return }
            DispatchQueue.main.async {
                //获取最新的完整数据
                if let allResult = collectionChanges.fetchResultAfterChanges as? PHFetchResult<PHAsset> {
                    self.assetsFetchResults = allResult
                }
                
                if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves {
                    return
                } else {
                    print("--- 监听到变化 ---")
                    //            //照片删除情况
                    //            if let removedIndexes = collectionChanges.removedIndexes, removedIndexes.count > 0{
                    //                print("删除了\(removedIndexes.count)张照片")
                    //            }
                    //            //照片修改情况
                    //            if let changedIndexes = collectionChanges.changedIndexes, changedIndexes.count > 0{
                    //                print("修改了\(changedIndexes.count)张照片")
                    //            }
                    //照片新增情况
                    if let insertedIndexes = collectionChanges.insertedIndexes, insertedIndexes.count > 0 {
                        print("新增了\(insertedIndexes.count)张照片")
                        //获取最后添加的图片资源
                        let asset = assetsFetchResults[insertedIndexes.first!]
                        //获取缩略图
                        PHImageManager.default().requestImage(for: asset, targetSize: self.setImgSize() , contentMode: .aspectFill, options: nil) { (image, info) in
                            self.getNewAddedImage(image, asset: asset)
                        }
                    }
                }
            }
        }
    }
    
    //图大小
    open func setImgSize() -> CGSize {
//        let scale = UIScreen.main.scale //像素?
//        let thumbnailSize = CGSize( width: ZSCREEN_WIDTH * 0.3 * scale , height: ZSCREEN_WIDTH * 0.3 * scale)
        return PHImageManagerMaximumSize
    }
    
    private func getAssetsFetchResults() {
        //启动后先获取目前所有照片资源
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        self.assetsFetchResults = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
    }
    
}

