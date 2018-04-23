//
//  DownloadAndFileController.swift
//  ZxpUtils
//
//  Created by ZXP on 2018/3/28.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import CJWUtilsS
import Alamofire
import Photos

class DownloadAndFileController: UITableViewController {
    
    var downloadName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Document路径"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "对指定路径执行浅搜索"
            return cell
        }
        if section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "保存图片到Document"
            return cell
        }
        if section == 2 {
            let cell = imgCell()
            return cell
        }
        if section == 3 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "删除文件"
            return cell
        }
        if section == 4 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "删除Document下的文件"
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

        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            DownloadAndFile.share.contentsOfURL()
        }
        if section == 1 {
            let image = UIImage(named: "favorite_select")
            let data:Data = UIImagePNGRepresentation(image!)!
            DownloadAndFile.share.saveImageToDocument(data, name: "favorite_select", suffixType: .png)
        }
        if section == 2 {
            let cell = tableView.cellForRow(at: indexPath) as! imgCell
            if let img = DownloadAndFile.share.readFileForImage("favorite_select.png") {
                cell.img.image = img
            } else {
                self.showText("失败")
                cell.img.image = UIImage(color: UIColor.white)
            }
        }
        if section == 3 {
            if DownloadAndFile.share.removefile("favorite_select.png") {
                self.showText("成功")
            } else {
                self.showText("失败")
            }
        }
        if section == 4 {
            DownloadAndFile.share.removeAllfile()
        }
        if section == 5 {
            let url = "http://119.23.148.218/file/insurance/%E4%B9%98%E5%AE%A2%E4%BA%BA%E8%BA%AB%E6%84%8F%E5%A4%96%E4%BC%A4%E5%AE%B3%E4%BF%9D%E9%99%A9%E6%9D%A1%E6%AC%BE.pdf"
            Daf.startDownloadUrl(url, fileName: nil, success: { (name, url, data) in
               self.downloadName = name
                print("文件下载成功: \(name)")
            }, fail: { error in
                print("文件下载错误: \(error)")
            }, progress: { pg in
                print("当前进度：\(pg * 100)%")
            })
        }
        if section == 6 {
            Daf.stopBtnClick()
        }
        if section == 7 {
            Daf.continueDownload(success: { (name, url, data) in
                self.downloadName = name
                print("继续文件下载成功: \(name)")
            }, fail: { error in
                print("继续文件下载错误: \(error)")
            }, progress: { pg in
                print("继续当前进度：\(pg * 100)%")
            })
        }
        if section == 8 {
            if Daf.isFileExistsForDocuments(downloadName) && downloadName.valid() {
                let filePath = NSHomeDirectory() + "/Documents/" + downloadName.urlEncoded()
                openPdfforWed(filePath)
            } else {
                self.showText("没有文件")
            }
        }
        
        if section == 9 {

        }
    }
    
    func openPdfforWed(_ filename: String) {
        let vc = CCWebViewController()
        if let nsurl = NSURL(string: filename) {
            let request = NSURLRequest(url: nsurl as URL)
            vc.webView.loadRequest(request as URLRequest)
            self.pushViewController(vc)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 4 ? 10 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = UIView()
        vv.backgroundColor = UIColor.orange
        return vv
    }
}

class imgCell: QPTableViewCell {
    
    let img = UIImageView()
    let texts = UILabel()

    override func setupViews(view: UIView) {
        view.addSubview(img)
        view.addSubview(texts)
        img.backgroundColor = UIColor.white
        texts.text = "从Document获取图片"
    }
    
    override func setupConstrains(view: UIView) {
        
        img.topAlign(view, predicate: "0")
        img.leadingAlign(view, predicate: "0")
        img.trailingAlign(view, predicate: "0")
        img.bottomAlign(view: view, predicate: "0")
        img.heightConstrain("100")
        
        texts.centerView(view)
    }
}

open class CCWebViewController: UIViewController, UIWebViewDelegate {
    
    open let webView = UIWebView()
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.frame = self.view.frame
        webView.delegate = self
        
    }
    
}
