//
//  ZXPScrollSelectViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/27.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import HMSegmentedControl

class ZXPScrollSelectViewController: UIViewController {
    
    private var containsView = UIView()
    private var topContainsView = UIView()
    private var bottomContainsView = UIView()
    private var mainScrollView = UIScrollView()
    ///选择的vc
    var oldController:UIViewController!
    ///选择的index
    var currentPage = 0
    
    ///是否让topView滚动
    open func isScrollTopView() -> Bool {
        return true
    }
    ///滚动时的ContentOffset.Y
    open func realimecContentOffsetY(_ yy:CGFloat) {
        
    }
    ///停止topView的滑动距离 要小于topViewHeight
    open func topViewSlideStop() -> CGFloat {
        return 0
    }
    ///顶部距离
    open func topPading() -> CGFloat {
        if let _ = self.navigationController {
            return safeAreaTopHeight
        }
        return 0
    }
    ///底部距离
    open func bottomPading() -> CGFloat {
        return safeAreabottomHeight
    }
    ///上边view的高
    open func topViewHeight() -> CGFloat {
        return 0
    }
    ///添加上边view
    open func topView() -> UIView? {
        return nil
    }
    ///下边view的高
    open func bottomViewHeight() -> CGFloat {
        return 0
    }
    ///添加下边view
    open func bottomView() -> UIView? {
        return nil
    }
    ///中间view的高 自动计算
    private func scrollViewHeight() -> CGFloat {
        return containsView.height - bottomViewHeight()
    }
    
    ///vc个数
    open func numberOfViewController() -> Int {
        return 1
    }
    ///添加vc
    open func addViewControllerAt(_ index: Int) -> UIViewController {
        return UIViewController()
    }
    ///设置vc   vc设置父vc之类
    open func setViewControllerAt(_ vc: UIViewController,index: Int) {
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initContainsView()
        initViewControllers()
    }
    ///添加底view
    private func initContainsView() {
        containsView.frame = CGRect(x: 0, y: topPading() , width: self.view.width, height: self.view.height - topPading() - bottomPading())
        containsView.backgroundColor = UIColor.green
        self.view.addSubview(containsView)
        
        mainScrollView.backgroundColor = UIColor.yellow
        mainScrollView.frame = CGRect(x: 0, y: 0, width: containsView.width, height: scrollViewHeight())
        containsView.addSubview(mainScrollView)
        configMainScrollView()
        
        topContainsView.backgroundColor = UIColor.alizarin()
        topContainsView.frame = CGRect(x: 0, y: 0, width: containsView.width, height: topViewHeight())
        containsView.addSubview(topContainsView)
        
        bottomContainsView.backgroundColor = UIColor.green
        bottomContainsView.frame = CGRect(x: 0, y: scrollViewHeight(), width: containsView.width, height: bottomViewHeight())
        containsView.addSubview(bottomContainsView)
        
        addView()
    }
    
    ///添加顶部和底部的view
    private func addView() {
        if let topView = topView() {
            topView.frame = topContainsView.bounds
            topContainsView.addSubview(topView)
        }
        if let bottomView = bottomView() {
            bottomView.frame = bottomContainsView.bounds
            bottomContainsView.addSubview(bottomView)
        }
    }
    ///添加ViewController
    private func initViewControllers() {
        let bounds = mainScrollView.bounds
        for index in 0..<numberOfViewController() {
            let vc = addViewControllerAt(index)
            let view = vc.view!
            if index == 0 {
//                mainScrollView.addSubview(view)
                oldController = vc
            }
            mainScrollView.addSubview(view)
            if let tv = view as? UITableView {
                tv.contentInset.top = topViewHeight()
                ///首先是增加一个观察者,然后是实现代理方法
                tv.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            }
            let frame  = CGRect(x: CGFloat(index) * bounds.width, y: 0, width: bounds.width, height: bounds.height)
            view.frame = frame
            setViewControllerAt(vc, index: index)
            self.addChildViewController(vc)
        }
    }
    
    ///设置ScrollView
    func configMainScrollView() {
        mainScrollView.contentSize = CGSize(width: CGFloat(self.numberOfViewController()) * mainScrollView.bounds.width, height: 0)
        mainScrollView.bounces = false
        mainScrollView.isPagingEnabled = true
        mainScrollView.delegate = self
    }
    
    ///观察者代理方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tv = object as? UITableView , keyPath == "contentOffset" , isScrollTopViewOK() {
            let contentOffsetY = tv.contentOffset.y
            realimecContentOffsetY(contentOffsetY)
            if contentOffsetY < -topViewSlideStop() && contentOffsetY >= -topViewHeight() {
                for vc in self.childViewControllers {
                    if let tv1 = vc.view as? UITableView, vc != oldController {
                        if tv1.contentOffset.y != tv.contentOffset.y {
                            tv1.contentOffset = tv.contentOffset
                        }
                    }
                }
                self.topContainsView.frame.origin.y = -contentOffsetY - topViewHeight()
            } else if contentOffsetY >= -topViewSlideStop() {
                self.topContainsView.frame.origin.y = -(topViewHeight() - topViewSlideStop())
            } else if contentOffsetY <= -topViewHeight() {
                self.topContainsView.frame.origin.y = 0
            }
        }
    }
    
    deinit {
        ///删除观察者
        for vc in self.childViewControllers {
            let view = vc.view
            if let tv = view as? UITableView {
                tv.removeObserver(self, forKeyPath: "contentOffset")
            }
        }
    }
    
    ///可以滑动?
    fileprivate func isScrollTopViewOK() -> Bool {
        return isScrollTopView() && topViewHeight() > topViewSlideStop()
    }
    
    ///滑动到哪里
    func scrollTo(_ index:Int) {
        if index < numberOfViewController() {
            mainScrollView.setContentOffset(CGPoint(x:mainScrollView.bounds.width * CGFloat(index) ,y:0) , animated: true)
        }
    }
}

extension ZXPScrollSelectViewController: UIScrollViewDelegate {
    
    //左右滑开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        if isScrollTopViewOK() {
            var maxOffsetY:CGFloat = -topViewHeight()
            for vc in self.childViewControllers {
                if let tv = vc.view as? UITableView {
                    if  tv.contentOffset.y > maxOffsetY {
                        maxOffsetY = tv.contentOffset.y
                    }
                }
            }
            ///同步contentOffset
            if maxOffsetY > -topViewSlideStop() {
                for (index,vc) in self.childViewControllers.enumerated() {
                    if let tv = vc.view as? UITableView ,currentPage != index {
                        let yy = tv.contentOffset.y
                        if yy < -topViewSlideStop()  {
                            tv.contentOffset.y = -topViewSlideStop()
                        }
                    }
                }
            }
        }
    }
    
    //左右滑结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        showViewControllerOf(index)
    }
    
    ///设置选择的vc
    public func showViewControllerOf(_ index: Int) {
        let vcs = self.childViewControllers
        if index < vcs.count {
            let tvc = vcs[index]
            if oldController != tvc {
//                self.transition(from: oldController, to: tvc, duration: 0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (bool) in
                    self.currentPage = index
                    self.oldController = tvc
//                })
            }
            selectIndexAndVC(index, vc: tvc)
        } else {
            print("超出范围")
        }
    }
    
    ///选择的index和vc
    open func selectIndexAndVC(_ index: Int,vc:UIViewController) {
        
    }
    
}

///继承这个
class ZXPScrollSelectViewControllerCS: ZXPScrollSelectViewController {
    
    var segment: HMSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfViewController() -> Int {
        return 3
    }
    
    override func addViewControllerAt(_ index: Int) -> UIViewController {
        if index == 0 {
            return firstViewController()
        } else if index == 1 {
            return secondViewController()
        } else if index == 2 {
            return thirdViewController()
        }
        return super.addViewControllerAt(index)
    }
    
    override func isScrollTopView() -> Bool {
        return true
    }
    
    override func topViewSlideStop() -> CGFloat {
        return 50
    }
    
    override func topViewHeight() -> CGFloat {
        return 150
    }
    
    override func topView() -> UIView? {
        let bg = UIView()
        let sv = initSegmentView()
        bg.addSubview(sv)
        sv.frame = CGRect(x: 0, y: 100, width: ZSCREEN_WIDTH, height: 50)
        return bg
    }
    
    override func bottomViewHeight() -> CGFloat {
        return 44
    }
    
    override func bottomView() -> UIView? {
        let vv = UILabel()
        vv.backgroundColor = UIColor.blue
        vv.text = "hahahahahahahhahha"
        return vv
    }
    
    override func realimecContentOffsetY(_ yy: CGFloat) {
        print("yy ----- \(yy)")
    }
    
    override func selectIndexAndVC(_ index: Int, vc: UIViewController) {
        self.segment.setSelectedSegmentIndex(UInt(index), animated: true)
        print("selectIndexAndVC ----- \(index) \(vc)")
    }
    
    override func selectSegmentedControlIndex(_ index: Int) {
        scrollTo(index)
    }
    
    override func customSegment(segment: HMSegmentedControl) -> HMSegmentedControl {
        self.segment = segment
        return segment
    }
    

}

