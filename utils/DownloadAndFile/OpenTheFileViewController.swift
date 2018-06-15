//
//  OpenTheFileViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/6/15.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

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
        documentController.presentPreview(animated: true)
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
