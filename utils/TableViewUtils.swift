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
    ///去掉多余的分隔线
    func setExtraCellLineHidden() {
        self.tableFooterView = UIView()
    }
    
}
