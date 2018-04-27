//
//  TestTransitionFromViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/24.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class firstViewController: ZXPFixedSelectChildTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        print("firstViewController - viewWillAppear")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("firstViewController - viewDidAppear")
    }
    
    deinit {
        print("销毁firstViewController")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        cell.textLabel?.text = "firstViewController - \(indexPath.section) --- \(rootSegment.sss)"
        cell.textLabel?.text = "firstViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rootSegment.sss = "\(indexPath.section)"
//        self.tableView.reloadData()
        print("\(atTheTopViewController())")
    }

}

class secondViewController: ZXPFixedSelectChildTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        print("secondViewController - viewWillAppear")

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("secondViewController - viewDidAppear")
    }
    
    deinit {
        print("销毁secondViewController")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        cell.textLabel?.text = "secondViewController - \(indexPath.section) --- \(rootSegment.sss)"
        cell.textLabel?.text = "secondViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rootSegment.sss = "\(indexPath.section)"
//        self.tableView.reloadData()
        self.showTextTime("哈哈哈哈")
    }

}

class thirdViewController: ZXPFixedSelectChildTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
        self.tableView.addRefreshHeader(target: self, action: #selector(requestMore))
//        self.tableView.mj_header.ignoredScrollViewContentInsetTop = -194
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        print("thirdViewController - viewWillAppear")

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("thirdViewController - viewDidAppear")

    }

    deinit {
        print("销毁thirdViewController")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "thirdViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
