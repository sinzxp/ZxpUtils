//
//  TestTransitionFromViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/24.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import CJWUtilsS

class TestTransitionFromViewController: UIViewController {
    
    var containsView = UIView()
    var containsScrollView = UIView()
    var topView = UIView()
    var bottomView = UIView()

    lazy var mainScrollView: UIScrollView = UIScrollView()
    
    var oldController:UIViewController!
    var currentPage = 0
    
    var imgs:[UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        containsView.frame = CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height - 64)
        containsView.backgroundColor = UIColor.green
        self.view.addSubview(containsView)

        let firstVC = firstViewController()
        self.addChildViewController(firstVC)
        let secondVC = secondViewController()
        self.addChildViewController(secondVC)
        let thirdVC = thirdViewController()
        self.addChildViewController(thirdVC)
        
        topView.backgroundColor = UIColor.randomColor
        topView.frame = CGRect(x: 0, y: 0, width: containsView.width, height: 150)
        configMainScrollView()
        containsView.addSubview(topView)
        let cc = UIView()
        topView.addSubview(cc)
        cc.backgroundColor = UIColor.orange
        cc.bottomAlign(topView, predicate: "0")
        cc.leadingAlign(topView, predicate: "0")
        cc.trailingAlign(topView, predicate: "0")
        cc.heightConstrain("50")
        oldController = firstVC
    }
    
    func configMainScrollView() {
        if mainScrollView.superview == nil {
            mainScrollView.frame = CGRect(x: 0, y: 0, width: containsView.width, height: containsView.height)
            self.containsView.addSubview(mainScrollView)
            // 设置内容视图的相关属性
            mainScrollView.contentSize = CGSize(width: CGFloat(self.childViewControllers.count) * mainScrollView.bounds.width, height: 0)
            mainScrollView.bounces = false
            mainScrollView.isPagingEnabled = true
            mainScrollView.delegate = self
        }
        configChildControllers()
    }
    
    /// 配置子控制器
    func configChildControllers() {
        // 遍历控制器数组
        for (index,vc) in self.childViewControllers.enumerated() {
            let view = vc.view
//            mainScrollView.addSubview(view!)
            let frame  = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
            view?.frame = frame
            if let tv = view as? UITableView {
                tv.contentInset.top = 150
                ///首先是增加一个观察者,然后是实现代理方法
                tv.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            }
//            let imgV = UIImageView(frame: frame)
//            let img = view!.viewShot()
//            imgV.image = img
//            imgs.append(imgV)
//            mainScrollView.addSubview(imgV)
        }
        mainScrollView.addSubview(self.childViewControllers[0].view)
    }
    
    func fitFrameForChildViewController(_ index:Int,_ chileViewController:UIViewController) {
        chileViewController.view.frame = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
    }
    
    ///观察者代理方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tv = object as? UITableView , keyPath == "contentOffset" {
            let contentOffsetY = tv.contentOffset.y
//            print("-----> \(contentOffsetY)")
            if contentOffsetY < -50 && contentOffsetY >= -150 {
                for vc in self.childViewControllers {
                    if let tv1 = vc.view as? UITableView, vc != oldController {
                        if tv1.contentOffset.y != tv.contentOffset.y {
                            tv1.contentOffset = tv.contentOffset
                        }
                    }
                }
                self.topView.frame.origin.y = -contentOffsetY - 150
            } else if contentOffsetY >= -50 {
                self.topView.frame.origin.y = -100
            } else if contentOffsetY <= -150 {
                self.topView.frame.origin.y = 0
            }
        }
    }
    
    deinit {
        for vc in self.childViewControllers {
            let view = vc.view
            if let tv = view as? UITableView {
                tv.removeObserver(self, forKeyPath: "contentOffset")
            }
        }
    }
}
//
extension TestTransitionFromViewController: UIScrollViewDelegate {
    
    //开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        var maxOffsetY:CGFloat = -150
        for vc in self.childViewControllers {
            if let tv = vc.view as? UITableView {
                if  tv.contentOffset.y > maxOffsetY {
                    maxOffsetY = tv.contentOffset.y
                }
            }
        }
        if maxOffsetY > -50 {
            for (index,vc) in self.childViewControllers.enumerated() {
                if let tv = vc.view as? UITableView ,currentPage != index {
                    let yy = tv.contentOffset.y
                    if yy < -50  {
                        tv.contentOffset.y = -50
                    }
                }
            }
        }
    }
    
    //结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let tvc = self.childViewControllers[currentPage]
        if tvc == oldController {
            return
        }
        self.transition(from: oldController, to: tvc, duration: 0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (bool) in
            self.currentPage = currentPage
            self.oldController = tvc
        })
    }
    
}

class firstViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear------ firstViewController")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear------ firstViewController")
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
        cell.textLabel?.text = "firstViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}

class secondViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear------ secondViewController")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear------ secondViewController")
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
        cell.textLabel?.text = "secondViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}

class thirdViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
        self.tableView.addRefreshHeader(target: self, action: #selector(requestMore))
//        self.tableView.mj_header.ignoredScrollViewContentInsetTop = -194
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear------ thirdViewController")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear------ thirdViewController")
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
