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
        return 5
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
            cell.textLabel?.text = "TestTransitionFromViewController"
            return cell
        }
        if section == 4 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "测试ZXPFixedSelectViewController"
            return cell
        }
        if section == 5 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "用Alamofire下载保存pdf文件"
            return cell
        }
        if section == 6 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "停止下载文件"
            return cell
        }
        if section == 7 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "继续下载文件"
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
            let vc = TestTransitionFromViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 4 {
            let vc = ZXPFixedSelectViewControllerCS()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 5 {

        }
        if section == 6 {
        }
        if section == 7 {

        }
        if section == 8 {
            
        }
        if section == 9 {

        }
    }

}
