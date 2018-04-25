//
//  TestTransitionFromViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/24.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class TestTransitionFromViewController: UIViewController {
    
    var containsScrollView = UIView()
    var topView = UIView()
    var bottomView = UIView()

    lazy var mainScrollView: UIScrollView = UIScrollView()
    var newViewController:UIViewController!
    var currentPage = 0
    var tvContentInsetTop:CGFloat = 0
    var topViewY:CGFloat = 0
    var tvOffsetY:CGFloat = 0
    
    var imgs:[UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstVC = firstViewController()
        self.addChildViewController(firstVC)
        let secondVC = secondViewController()
        self.addChildViewController(secondVC)
        let thirdVC = thirdViewController()
        self.addChildViewController(thirdVC)
        
        topView.backgroundColor = UIColor.randomColor
        topView.frame = CGRect(x: 0, y: 64, width: ZSCREEN_WIDTH, height: 150)
        configMainScrollView()
        self.view.addSubview(topView)
        newViewController = firstVC
    }
    
    func configMainScrollView() {
        if mainScrollView.superview == nil {
            mainScrollView.frame = CGRect(x: 0, y: 64, width: ZSCREEN_WIDTH, height: ZSCREEN_HEIGHT - 64)
//            mainScrollView.frame = self.view.frame
            self.view.addSubview(mainScrollView)
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
            mainScrollView.addSubview(view!)
            let frame  = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
            view?.frame = frame
            if let tv = view as? UITableView {
                tv.contentInset.top = 150
                ///首先是增加一个观察者,然后是实现代理方法
                tv.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            }
            
//            let imgV = UIImageView(frame: frame)
//            let img = vc.view.viewShot()
//            imgV.image = img
//            imgs.append(imgV)
//            mainScrollView.addSubview(imgV)
        }
//        mainScrollView.addSubview(self.childViewControllers[0].view)
    }
    
    func fitFrameForChildViewController(_ index:Int,_ chileViewController:UIViewController) {
        chileViewController.view.frame = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
    }
    
    ///观察者代理方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tv = object as? UITableView , keyPath == "contentOffset" {
            let contentOffsetY = tv.contentOffset.y
            print("\(contentOffsetY)")
            if contentOffsetY < -44 && contentOffsetY > -150 {
//                tv.contentInset.top = 150 - contentOffsetY
                    for (index,vc) in self.childViewControllers.enumerated() {
                        if let tv1 = vc.view as? UITableView ,currentPage != index {
                            if tv1.contentOffset.y != tv.contentOffset.y {
                                tv1.contentOffset = tv.contentOffset
                            }
                        }
                    }
                self.topView.frame.origin.y = 64 - contentOffsetY - 150
            } else if contentOffsetY >= -44 {
                self.topView.frame.origin.y = -44
            }else if contentOffsetY <= -150 {
//                tv.contentInset.top = 150
                self.topView.frame.origin.y = 64
            }
//            tvContentInsetTop = tv.contentInset.top
//            topViewY = self.topView.frame.origin.y
            tvOffsetY = tv.contentOffset.y
        }
    }
}
//
extension TestTransitionFromViewController: UIScrollViewDelegate {
    
    //开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        var maxOffsetY:CGFloat = 0
//        for vc in self.childViewControllers {
//            if let tv = vc.view as? UITableView {
//                if  tv.contentOffset.y > maxOffsetY {
//                    maxOffsetY = tv.contentOffset.y
//                }
//            }
//        }
//        if tvOffsetY <= -44 {
            for (index,vc) in self.childViewControllers.enumerated() {
                if let tv = vc.view as? UITableView ,currentPage != index {
//                    tv.contentInset.top = tvContentInsetTop
                    let yy = tv.contentOffset.y
                    print("yy -- \(yy)")
                    if yy > -44  {
                        tv.contentOffset.y = tvOffsetY
                    }
//                    else if yy {
//
//                    }
//                    if tv.contentOffset.y < -44 {
//                        tv.contentOffset = CGPoint(x: 0, y: -44)
//                    }
                }
            }
//        }
    }
    
    //结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let tvc = self.childViewControllers[currentPage]
        if tvc == newViewController {
            return
        }
        self.currentPage = currentPage

//        self.fitFrameForChildViewController(currentPage, tvc)
//        self.transition(from: newViewController, to: tvc, duration: 0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (bool) in
//            self.fitFrameForChildViewController(self.oidCurrentPage, self.newViewController)
//            self.oidCurrentPage = currentPage
//            self.configChildControllers()
            
//            let img = self.view.viewShot()?.shearImage(scrollView.frame)
//            self.imgs[self.oldCurrentPage].image = img
//            self.oldCurrentPage = currentPage
            
            self.newViewController = tvc
//            tvc.didMove(toParentViewController: self)
//        })
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
        cell.textLabel?.text = "\(indexPath.section)"
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
        cell.textLabel?.text = "\(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}

class thirdViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
        self.tableView.addRefreshHeader(target: self, action: #selector(requestMore))
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
        cell.textLabel?.text = "\(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
