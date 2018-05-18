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
        return 12
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
        if section == 9 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "保存图片1"
            return cell
        }
        if section == 10 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "保存图片2"
            return cell
        }
        if section == 11 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "模糊"
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
//                print("\(assets)-----\(assets.count)")
                self.tableView.reloadData()
                PhotoAlbumUtil.PHAssetUrl(assets[0]) { url in
                    self.Toast.showToast("\(String(describing: url))")
                }
            }
        }
        if section == 2 {
            self.presentImagePicker(maxSelected: 5) { (imgs) in
//                print("\(imgs)-----\(imgs.count)")
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
                self.Toast.showToastExt("无图", delay: 1, position: .Bottom)
            }
            self.tableView.reloadData()
        }
        if section == 9 {
            let picker = ZXPAppleImagePickerController()
            picker.pickerImage(vc: self,maxSelected:1, block: { (imgs) in
                PhotoAlbumUtil.SaveImageInAlbum(image: imgs[0], albumName: "zxp") { (result) in
                    switch result{
                    case .success:
                        self.Toast.showToast("保存成功")
                    case .error:
                        self.Toast.showToast("保存错误")
                    }
                }
            })
        }
        if section == 10 {
            let picker = ZXPAppleImagePickerController()
            picker.pickerImage(vc: self,maxSelected:1, block: { (imgs) in
                self.savedPhoto(imgs[0])
            })
        }
        if section == 11 {
            let vc = BlurVC()
            self.navigationController?.pushViewController(vc, animated: true)
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
    
//    override func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
//        print("tu")
//    }

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

class BlurVC:UIViewController {
    
    var imgView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模糊"
        self.view.backgroundColor = UIColor.white
        imgView = UIImageView(image:UIImage(named:"idcard3"))
        imgView.frame = CGRect(x:0, y:100, width:ZSCREEN_WIDTH, height:200)
        self.view.addSubview(imgView)
        
        let slider = UISlider(frame:CGRect(x:0, y:0, width:300, height:50))
        slider.center = self.view.center
        self.view.addSubview(slider)
        
//        slider.isContinuous = false  //滑块滑动停止后才触发ValueChanged事件
        slider.addTarget(self,action:#selector(sliderDidchange(_:)), for:UIControlEvents.valueChanged)
        bbbb()
    }
    
    func sliderDidchange(_ slider:UISlider){
        print(slider.value)

    }
    
    func bbbb() {
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小（全屏）
        blurView.frame = imgView.bounds
        
        //创建并添加vibrancy视图   放在这里的东西比较突出 可以不创建
        let vibrancyView = UIVisualEffectView(effect:UIVibrancyEffect(blurEffect: blurEffect))
        vibrancyView.frame = imgView.bounds
        blurView.contentView.addSubview(vibrancyView)
        
        //将文本标签添加到vibrancy视图中
        let label=UILabel(frame:CGRect(x: 10, y: 10, width: 2000, height: 50) )
        label.text = "hangge.com"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        label.textAlignment = .center
        label.textColor = UIColor.white
        vibrancyView.contentView.addSubview(label)
        
        self.imgView.addSubview(blurView)
        
    }
}
