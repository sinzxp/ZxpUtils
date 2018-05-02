//
//  ImagePickerAndBrowserController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/3.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Photos

class ImagePickerAndBrowserController: UITableViewController {
    
    var imgs:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片选择"
        self.tableView.setExtraCellLineHidden()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return self.imgs.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "自己写"
            return cell
        }
        if section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "自己写presentAssetsPicker"
            return cell
        }
        if section == 2 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "自己写presentImagePicker"
            return cell
        }
        if section == 3 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "选择相机或图库"
            return cell
        }
        if section == 4 {
            let cell = imgAbcCell()
            cell.texts.text = "\(row)"
            cell.img.image = imgs[row]
            return cell
        }
        if section == 5 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "摄像"
            return cell
        }
        if section == 6 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "屏幕截图"
            return cell
        }
        if section == 7 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "view截图"
            return cell
        }
        if section == 8 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "监听相册变化 获取最新添加的图片"
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            let vc = UINavigationController(rootViewController: ZXPImagePickerTableVC())
            self.present(vc, animated: true, completion: {
                
            })
        }
        if section == 1 {
            self.presentAssetsPicker(maxSelected: 5) { (assets) in
                print("\(assets)-----\(assets.count)")
                self.tableView.reloadData()
            }
        }
        if section == 2 {
            self.presentImagePicker(maxSelected: 5) { (imgs) in
                print("\(imgs)-----\(imgs.count)")
                self.imgs = imgs
                self.tableView.reloadData()
            }
        }
        if section == 3 {
            let picker = ZXPAppleImagePickerController()
            picker.isEditor = true
            picker.isSavedPhoto = true
            picker.pickerImage(vc: self,maxSelected:5, block: { (imgs) in
                self.imgs = imgs
                self.tableView.reloadData()
                
            })
        }
        if section == 4 {
            toImageBrowser()
        }
        if section == 5 {
            let vc = ZXPAppleVideoController()
            vc.videoShow(self)
        }
        if section == 6 {
            let img = screenShot(true)
            self.imgs.append(img!)
            self.tableView.reloadData()
        }
        if section == 7 {
            let img = tableView.viewShot(true)
            self.imgs.append(img!)
            self.tableView.reloadData()
        }
        if section == 8 {
            self.imgs.removeAll()
            ///获取最新添加的图片 监听相册变化
            if let img = Zuser.sharedInstance.Zimg {
                imgs.append(img)
            } else {
                self.showTextTime("无图")
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 150
        } else {
            return 44
        }
    }
    
    func toImageBrowser() {
        let vc = ZXPImageBrowserVC()
        vc.images = imgs
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

class imgAbcCell: UITableViewCell {
    
    let img = UIImageView()
    let texts = UILabel()
    
    public func setup() {
        self.contentView.addSubview(img)
        self.contentView.addSubview(texts)
        img.backgroundColor = UIColor.white
        img.contentMode = .scaleAspectFit
        texts.text = "图片"
    }
    
    override func layoutSubviews() {
        img.frame = self.contentView.frame
        texts.frame = self.contentView.frame
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
