//
//  TextTableViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/21.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import SwiftyJSON

class TextTableViewController: UITableViewController {
    
    let titles = ["TextView","拷贝","选择城市"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "文本"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titles[indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            let vc = TextViewViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 1 {
            let vc = LabelViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 2 {
            let vc = ZXPCitySelectionTVC()
            vc.block = sss
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    ///UIMenuController菜单 点击执行
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
    ///UIMenuController菜单 显示的选项
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        return true
    }
    
    ///显示UIMenuController这种菜单
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func sss(_ records: [JSON]) -> () {
        print("\(records)")
    }
}


class TextViewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let textview = UITextView(frame:self.view.bounds)
        textview.layer.borderWidth = 1  //边框粗细
        textview.layer.borderColor = UIColor.gray.cgColor //边框颜色
        textview.isEditable = false
        textview.isSelectable = true
        textview.dataDetectorTypes = UIDataDetectorTypes.all //电话和网址都加链接
        textview.textAlignment = .center
        self.view.addSubview(textview)
        
        textview.text = "https://www.baidu.com iRate could not find your app on iTunes. If your app is not yet on the store or is not intended for App Store release then don't worry about this 13128562807 5232748"
        
        let mail = UIMenuItem(title: "邮件", action: #selector(onMail))
        let weixin = UIMenuItem(title: "微信", action: #selector(onWeiXin))
        let menu = UIMenuController()
        menu.menuItems = [mail,weixin]
    }
    
    func onMail(){
        print("mail")
    }
    
    func onWeiXin(){
        print("weixin")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class LabelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let textLabel = ZXPCopyLabel()
        textLabel.frame = CGRect(x: 0, y: 70, width: self.view.width , height: 40)
        textLabel.layer.borderWidth = 1  //边框粗细
        textLabel.layer.borderColor = UIColor.gray.cgColor //边框颜色
        textLabel.textAlignment = .center
        textLabel.text = "iRate could not find your app on iTunes."
        self.view.addSubview(textLabel)
        
    }
}
