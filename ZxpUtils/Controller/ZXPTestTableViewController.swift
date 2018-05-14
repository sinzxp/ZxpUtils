//
//  ZXPTestTableViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/3.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPTestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试首页"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "下载和文件操作"
            return cell
        }
        if section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "图片选择器和图片浏览器,图片其他操作"
            return cell
        }
        if section == 2 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "弹窗测试"
            return cell
        }
        if section == 3 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "测试_滑动的选择VC菜单TestTransitionFromViewController"
            return cell
        }
        if section == 4 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "测试_固定的选择VC菜单ZXPFixedSelectViewController"
            return cell
        }
        if section == 5 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "获取App和设备信息"
            return cell
        }
        if section == 6 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "点击事件动画"
            return cell
        }
        if section == 7 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "77777"
            return cell
        }
        if section == 8 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "网页打开pdf"
            return cell
        }
        if section == 9 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "测试相册"
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            let vc = DownloadAndFileController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 1 {
            let vc = ImagePickerAndBrowserController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 2 {
            let vc = ZXPPopupWindowTestTabBar()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 3 {
            let vc = ZXPScrollSelectViewControllerCS()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 4 {
            let vc = ZXPFixedSelectViewControllerCS()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 5 {
            let vc = AppAndDeviceInfoVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 6 {
            let vc = ClickOnTheViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 7 {
        }
        if section == 8 {
            
        }
        if section == 9 {

        }
    }
    
}

class AppAndDeviceInfoVC: UIViewController {
    
    let apptext = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AppAndDeviceInfo"
        let bb1 = UILabel()
        bb1.text = "跳转到apps"
        bb1.backgroundColor = UIColor.orange
        bb1.frame = CGRect(x: 0, y: 64, width: ZSCREEN_WIDTH / 2, height: 44)
        self.view.addSubview(bb1)
        bb1.addTapViewGesture(self, action: #selector(toAPPStore))
        let bb2 = UILabel()
        bb2.text = "appstore中应用的信息"
        bb2.backgroundColor = UIColor.purple
        bb2.frame = CGRect(x: ZSCREEN_WIDTH / 2, y: 64, width: ZSCREEN_WIDTH / 2, height: 44)
        self.view.addSubview(bb2)
        bb2.addTapViewGesture(self, action: #selector(getAPPStoreInfo))

        let text = UITextView()
        text.frame = CGRect(x: 0, y: 108, width: ZSCREEN_WIDTH, height: (ZSCREEN_HEIGHT - 108) / 2)
        self.view.addSubview(text)
        let info = AppAndDeviceInfoManager()
        text.text = "应用程序信息\n\(info.bundId)\n\(info.appName)\n\(info.appVersion)\n\(info.appBuildVersion)\n设备信息\n\(info.iosVersion)\n\(String(describing: info.identifierNumber))\n\(info.systemName)\n\(info.model)\n\(info.modelName)\n\(info.localizedModel)"
        
        apptext.frame = CGRect(x: 0, y: 108 + (ZSCREEN_HEIGHT - 108) / 2 , width: ZSCREEN_WIDTH, height: (ZSCREEN_HEIGHT - 108) / 2)
        self.view.addSubview(apptext)
        apptext.backgroundColor = UIColor.purple
    }
    
    func toAPPStore() {
        AppAndDeviceInfoManager.toAPPStore("1179213465")
    }
    
    func getAPPStoreInfo() {
        let ss = AppAndDeviceInfoManager.getAPPStoreInfo("1179213465")
        print("appstore中应用的信息\n\(String(describing: ss))")
        apptext.text = "\(ss)"
    }
    
}
