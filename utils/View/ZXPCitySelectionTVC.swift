//
//  ZXPCitySelectionTVC.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/21.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import SwiftyJSON

///选择城市TableViewController版
class ZXPCitySelectionTVC: UITableViewController {

    var datas:[JSON] = []
    
    var provinces:[JSON] = []
    var citys:[JSON] = []
    var divisions:[JSON] = []
    var records:[JSON] = []
    
    typealias CitySelectionBlock = (_ records: [JSON]) -> ()
    var block: CitySelectionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "area", ofType: "txt")!
        let txt = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        provinces = JSON(parseJSON:txt!).arrayValue
        
        filtration1()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return records.count
        }
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let info = records[row]["name"].stringValue
            let cell = UITableViewCell()
            cell.textLabel?.text = info
            return cell
        } else {
            let info = datas[row]
            let cell = UITableViewCell()
            cell.textLabel?.text = info["name"].stringValue
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                records.removeAll()
            } else if row == 1 {
                records.removeLast()
            }
            filtration1()
        } else {
            let info = datas[row]
            records.append(info)
            if records.count > 2 {
                self.block!(records)
                self.popVC()
                return
            }
            filtration(row)
        }
        self.tableView.reloadData()
    }
    
    func filtration1() {
        let ss = records.count
        if ss == 0 {
            datas = provinces
        } else if ss == 1 {
            datas = citys
        }
    }
    
    func filtration(_ index:Int) {
        let ss = records.count
        if ss == 0 {
            datas = provinces
        } else if ss == 1 {
            let info = provinces[index]
            let level2 = info["level2"].arrayValue
            var infos:[JSON] = []
            for item in level2 {
                infos.append(item)
            }
            if infos.isEmpty {
                self.block!(records)
                self.popVC()
            } else {
                citys = infos
                datas = infos
            }
        } else if ss == 2 {
            let info = citys[index]
            let level3 = info["level3"].arrayValue
            var infos:[JSON] = []
            for item in level3 {
                infos.append(item)
            }
            if infos.isEmpty {
                self.block!(records)
                self.popVC()
            } else {
                divisions = infos
                datas = infos
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
}
