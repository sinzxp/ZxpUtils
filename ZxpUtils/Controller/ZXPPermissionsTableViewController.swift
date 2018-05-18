//
//  ZXPPermissionsTableViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/17.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPPermissionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "权限"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "打开设置"
            return cell
        }
        if section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "相机权限"
            return cell
        }
        if section == 2 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "麦克风权限"
            return cell
        }
        if section == 3 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "相册权限"
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
            ZXPPermissionsUtils.toOpenSetting()
        }
        if section == 1 {
            self.Toast.showToast("\(ZXPPermissionsUtils.isPermissions(.Video))")
        }
        if section == 2 {
            self.Toast.showToast("\(ZXPPermissionsUtils.isPermissions(.Audio))")
        }
        if section == 3 {
            
            self.Toast.showToast("\(ZXPPermissionsUtils.isPhotoLibraryPermissions())")
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
