//
//  OpenTheFileViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/6/15.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import QuickLook

///不要用
////用QuickLook打开文件 可以多个 最好还是写在要用的控制器里 这个第二个链接会报错
class OpenTheFileToQuickLook:NSObject, QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    
    var urls:[URL] = []
    
    init(_ vc:UIViewController,urls:[URL]) {
        super.init()
        toQuickLook(vc, urls: urls)
    }
    
    func toQuickLook(_ vc:UIViewController,urls:[URL]) {
        self.urls = urls
        let previewController = QLPreviewController()
        previewController.dataSource =  self
        previewController.delegate =  self
        vc.present(previewController, animated: true) {}
        
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return urls.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return urls[index] as QLPreviewItem
    }
    
}

////打开文件 单个 写在控制器里 不要用这个
/*
 注意点有：
 1.要实现UIDocumentInteractionController的代理方法必须遵守UIDocumentInteractionControllerDelegate协议。
 2.UIDocumentInteractionController属性必须使用retain或strong修饰，控制器必须持有该对象。
 3.代码中的两个路径都可以使用。
 4.弹出面板的方法一个不展示可选操作，一个展示可选操作。
 5.直接使用presentPreviewAnimated:方法弹出预览。
 6.结合代理方法documentInteractionControllerViewControllerForPreview:显示预览操作。
 */
class OpenTheFileViewController: UIViewController ,UIDocumentInteractionControllerDelegate {

    var documentController:UIDocumentInteractionController!
    var previewUrl:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = previewUrl {
            toUIDocumentInteractionController(url)
        }
    }
    
    func toUIDocumentInteractionController(_ filename: URL) {
        let url = filename
        documentController = UIDocumentInteractionController(url: url)
        documentController.delegate = self
        ///直接打开
        documentController.presentPreview(animated: true)
        ///弹出选择菜单
//        let ss = documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
//        let ss = documentController.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
//        print(ss)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        print("文件分享面板退出时调用")
    }
    
    func documentInteractionControllerWillPresentOpenInMenu(_ controller: UIDocumentInteractionController) {
        print("文件分享面板弹出的时候调用")
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        print("当选择一个文件分享App的时候调用 --- \(String(describing: application))")
    }

}
