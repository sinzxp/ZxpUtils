//
//  ZXPImagePickerTableVC.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/3.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

//相簿列表项
class AlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
    
    init(title:String?,fetchResult:PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }
}
///相册new这个  可以显示IC上的图片并下载
class ZXPImagePickerTableVC: UITableViewController {
    
    var completeHandlerPHA:((_ assets:[PHAsset])->())?
    var completeHandlerIMG:((_ images:[UIImage])->())?
    var maxSelected:Int = 9
    
    //相簿列表项集合
    var items:[AlbumItem] = []
    
    ///第一次加载
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "照片库"
        let leftBarItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action:#selector(ZXPImagePickerTableVC.cancel) )
        self.navigationItem.rightBarButtonItem = leftBarItem
        self.tableView.setExtraCellLineHidden()
        //注册通知 监听资源改变
        PHPhotoLibrary.shared().register(self)
        
        getCollection()
    }
    
    func  cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///获取相册
    func getCollection() {
        
        items.removeAll()
        // 列出所有系统的智能相册
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartOptions)
        self.convertCollection(collection: smartAlbums)
        
        //列出所有用户创建的相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        self.convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
        
        //相册按包含的照片数量排序（降序）
        self.items.sort { (item1, item2) -> Bool in
            return item1.fetchResult.count > item2.fetchResult.count
        }
        
        self.tableView.reloadData()
        
    }
    
    //转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        
        for i in 0..<collection.count{
            //获取出当前相簿内的图片
            let resultsOptions = PHFetchOptions()
            //排序
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            //获取类型 图片
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//            视频
//            NSPredicate(format:"mediaType = %d", PHAssetMediaType.video.rawValue)
//            确实是可以做这种筛选的，比如筛选创建时间
//            NSPredicate(format:"creationDate > %@ AND creationDate < %@", startDate, endDate)
//            筛选时长
//            NSPredicate(format: "mediaType = %d AND duration > %f", PHAssetMediaType.Video.rawValue,dur)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0{
                let title = titleOfAlbumForChinse(c.localizedTitle)
                items.append(AlbumItem(title: title, fetchResult: assetsFetchResult))
            }
        }
        
    }
    
    //由于系统返回的相册集名称为英文，我们需要转换为中文
    private func titleOfAlbumForChinse(_ title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        } else if title == "Live Photos" {
            return "实况照片"
        } else if title == "Animated" {
            return "动图"
        } else if title == "Time-lapse" {
            return "延时摄影"
        }
        return title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstLoad {
            let vc = ZXPImagePickerGridVC()
            vc.maxSelected = maxSelected
            vc.completeHandlerPHA = completeHandlerPHA
            vc.completeHandlerIMG = completeHandlerIMG
            self.navigationController?.pushViewController(vc, animated: false)
        }
        firstLoad = false
    }
    
    deinit {
        ///干掉通知
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        print("销毁ZXPImagePickerTableVC")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = self.items[indexPath.section]
        cell.textLabel?.text = item.title == nil ? "相册" : item.title! + "\t(\(item.fetchResult.count))"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.section]
        let vc = ZXPImagePickerGridVC()
        vc.title = item.title
        vc.fetchResult = item.fetchResult
        vc.maxSelected = maxSelected
        vc.completeHandlerPHA = completeHandlerPHA
        vc.completeHandlerIMG = completeHandlerIMG
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
}

//监听资源改变 PHPhotoLibraryChangeObserver代理实现，图片新增、删除、修改开始后会触发
extension ZXPImagePickerTableVC:PHPhotoLibraryChangeObserver{
    
    //当照片库发生变化的时候会触发
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        getCollection()
    }
    
}
