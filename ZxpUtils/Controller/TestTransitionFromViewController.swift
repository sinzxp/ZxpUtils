//
//  TestTransitionFromViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/24.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class TestTransitionFromViewController: UIViewController {
    
    var mainScrollView: UIScrollView = UIScrollView()
    var newViewController:UIViewController!
    var oidCurrentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstVC = firstViewController()
        self.addChildViewController(firstVC)
//        firstVC.view.frame = CGRect(x: 0, y: 108, width: ZSCREEN_WIDTH, height: ZSCREEN_HEIGHT - 108)
        
        let secondVC = secondViewController()
        self.addChildViewController(secondVC)
//        secondVC.view.frame = CGRect(x: 0, y: 108, width: ZSCREEN_WIDTH, height: ZSCREEN_HEIGHT - 108)
        
        let thirdVC = thirdViewController()
        self.addChildViewController(thirdVC)
//        thirdVC.view.frame = CGRect(x: 0, y: 108, width: ZSCREEN_WIDTH, height: ZSCREEN_HEIGHT - 108)
        
        let bb1 = UIView()
        bb1.backgroundColor = UIColor.randomColor
        self.view.addSubview(bb1)
        bb1.addTapViewGesture(self, action: #selector(tapHandler))
        bb1.frame = CGRect(x: 0, y: 64, width: ZSCREEN_WIDTH, height: 44)
        configMainScrollView()
        
        newViewController = firstVC
    }
    
    func configMainScrollView() {
        if mainScrollView.superview == nil {
            mainScrollView.frame = CGRect(x: 0, y: 108, width: ZSCREEN_WIDTH, height: ZSCREEN_HEIGHT - 108)
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
        mainScrollView.addSubview(self.childViewControllers[0].view)
        // 遍历控制器数组
        for (index,vc) in self.childViewControllers.enumerated() {
//            mainScrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
        }
    }
    
    func fitFrameForChildViewController(_ index:Int,_ chileViewController:UIViewController) {
        chileViewController.view.frame = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
    }
    
    func tapHandler(sender:UITapGestureRecognizer) {
        self.transition(from: self.childViewControllers[0], to: self.childViewControllers[1], duration: 0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (bool) in
            
        })
    }
}

extension TestTransitionFromViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let tvc = self.childViewControllers[currentPage]
//        self.fitFrameForChildViewController(currentPage, tvc)
        self.transition(from: newViewController, to: tvc, duration: 0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (bool) in
//            self.fitFrameForChildViewController(self.oidCurrentPage, self.newViewController)
//            self.oidCurrentPage = currentPage
//            self.configChildControllers()
            self.newViewController = tvc
//            tvc.didMove(toParentViewController: self)
        })
    }
    
}



class firstViewController: UIViewController {
    
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

}

class secondViewController: UIViewController {
    
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

}

class thirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
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
}
