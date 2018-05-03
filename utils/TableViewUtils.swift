//
//  TableViewUtils.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/3.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class TableViewUtils: NSObject {

}

extension UITableView {
    //MARK: - 去掉多余的分隔线
    func setExtraCellLineHidden() {
        self.tableFooterView = UIView()
    }
    
}

//MARK: - 运用泛型实现不重用的UITableView
extension UITableView {
    /*
     弹出一个静态的cell，无须注册重用，就是不重复reuseIdentifier 例如:
     let cell: ZXPTableViewCell = tableView.dequeueStaticCell(indexPath)
     即可返回一个类型为GrayLineTableViewCell的对象
     - parameter indexPath: cell对应的indexPath
     - returns: 该indexPath对应的cell
     */
    func dequeueStaticCell<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        let reuseIdentifier = "staticCellReuseIdentifier - \(indexPath.description)"
        if let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
            return cell
        }else {
            let cell = T(style: .default, reuseIdentifier: reuseIdentifier)
            return cell
        }
    }
}

