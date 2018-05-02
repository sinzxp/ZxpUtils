//
//  ZXPPopupWindowTestTableViewController.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/4/20.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPPopupWindowTestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "弹窗测试"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if section == 0 {
            cell.textLabel?.text = "选择"
            return cell
        }
        if section == 1 {
            cell.textLabel?.text = "自动消失"
            return cell
        }
        if section == 2 {
            cell.textLabel?.text = "输入框"
            return cell
        }
        if section == 3 {
            cell.textLabel?.text = "获取顶层vc"
            return cell
        }
        if section == 4 {
            cell.textLabel?.text = "present模态弹窗"
            return cell
        }
        if section == 5 {
            cell.textLabel?.text = "wwwwwwww"
            return cell
        }
        if section == 6 {
            cell.textLabel?.text = ""
            return cell
        }
        if section == 7 {
            cell.textLabel?.text = ""
            return cell
        }
        if section == 8 {
            cell.textLabel?.text = ""
            return cell
        }
        if section == 9 {
            cell.textLabel?.text = ""
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            self.showActionSheet(["hhhhhh","dasdada","dddwqdqwdqfw"], title: "好啊叫", message: "哈哈哈") { (index) in
                print(index)
            }
        }
        if section == 1 {
            self.showActionTime(3, title: "5555", message: "666666")
        }
        if section == 2 {
            self.showActionTextField(keys: ["电话号码","密码","鬼鬼"],title:"测试", message: "哈哈哈", textFields: { (textField, index) in
                print(index)
                if index == 1 {
                    textField.isSecureTextEntry = true
                }
            }) { (tests) in
                print(tests)
            }
        }
        if section == 3 {
            let vc = atTheTopViewController()
            let bg = UIView()
            bg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            bg.frame = vc!.view.frame
            bg.addTapViewGesture(self, action: #selector(deleteView))
            vc?.view.addSubview(bg)
        }
        if section == 4 {
            let vc = ZXPPopModalVc()
            let vv = UILabel()
            vv.text = "5"
            vv.backgroundColor = UIColor.orange
            vv.frame.size = CGSize(width: 200, height: 200)
            vc.setContentView(vv, isClickBackgroundDismiss: true)
            vc.toPresent()
        }
        if section == 5 {
            ZXPToastView().showLoadingTexts("哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈",position:.Top)
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
    
    func deleteView(_ bb:UITapGestureRecognizer) {
        bb.view?.removeFromSuperview()
    }
    
}

class ZXPPopupWindowTestTabBar:UITabBarController {
    
    override func viewDidLoad() {
        
        let vc1 = ZXPPopupWindowTestTableViewController()
        let vc2 = ZXPPopupWindowTestTableViewController()
        self.addChildViewController(vc1)
        self.addChildViewController(vc2)

    }
}

