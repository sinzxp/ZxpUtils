//
//  ZXPFixedSelectViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/26.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

public class ZXPFixedSelectViewController: UIViewController {

    private var containsView = UIView()
    private var topContainsView = UIView()
    private var middleContainsView = UIView()
    private var bottomContainsView = UIView()
    
    var oldController:UIViewController!
    var currentPage = 0
    
    ///顶部距离
    open func topPading() -> CGFloat {
        return safeAreaTopHeight
    }
    ///底部距离
    open func bottomPading() -> CGFloat {
        return safeAreabottomHeight
    }
    
    open func topViewHeight() -> CGFloat {
        return 0
    }
    
    open func topView() -> UIView? {
        return nil
    }
    
    open func bottomViewHeight() -> CGFloat {
        return 0
    }
    
    open func bottomView() -> UIView? {
        return nil
    }
    
    private func middleViewHeight() -> CGFloat {
        return containsView.height - topViewHeight() - bottomViewHeight()
    }
    
    private func middleView() -> UIView? {
        return nil
    }
    
    open func addViewControllers() -> [UIViewController] {
        return []
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initContainsView()
        initViewControllers()
    }
    
    private func initContainsView() {
        containsView.frame = CGRect(x: 0, y: topPading() , width: self.view.width, height: self.view.height - topPading() - bottomPading())
        containsView.backgroundColor = UIColor.green
        self.view.addSubview(containsView)
        
        topContainsView.backgroundColor = UIColor.alizarin()
        topContainsView.frame = CGRect(x: 0, y: 0, width: containsView.width, height: topViewHeight())
        containsView.addSubview(topContainsView)
        
        middleContainsView.backgroundColor = UIColor.yellow
        middleContainsView.frame = CGRect(x: 0, y: topViewHeight(), width: containsView.width, height: middleViewHeight())
        containsView.addSubview(middleContainsView)
        
        bottomContainsView.backgroundColor = UIColor.green
        bottomContainsView.frame = CGRect(x: 0, y: topViewHeight() + middleViewHeight(), width: containsView.width, height: bottomViewHeight())
        containsView.addSubview(bottomContainsView)
        
        addView()
    }
    
    private func addView() {
        if let topView = topView() {
            topView.frame = topContainsView.frame
            topContainsView.addSubview(topView)
        }
        if let bottomView = bottomView() {
            bottomView.frame = bottomContainsView.frame
            bottomContainsView.addSubview(bottomView)
        }
    }

    private func initViewControllers() {
        let vcs = addViewControllers().isEmpty ? self.childViewControllers : addViewControllers()
        let frame = middleContainsView.bounds
        for (index,vc) in vcs.enumerated() {
            let view = vc.view!
            if index == 0 {
                middleContainsView.addSubview(view)
                oldController = vc
            }
            self.addChildViewController(vc)
            view.frame = frame
        }
    }
    
    public func showViewControllerOf(_ index: Int) {
        let vcs = self.childViewControllers
        let tvc = vcs[index]
        if index < vcs.count && oldController != tvc {
            self.transition(from: oldController, to: tvc, duration: 0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (bool) in
                self.currentPage = index
                self.oldController = tvc
            })
        } else {
            print("超出范围")
        }
    }

}

class ZXPFixedSelectViewControllerCS: ZXPFixedSelectViewController {
    
    override func addViewControllers() -> [UIViewController] {
        let vc = thirdViewController()
        return [vc]
    }
    
    override func topViewHeight() -> CGFloat {
        return 44
    }
    
    override func topView() -> UIView? {
        let bg = UIView()
        let l1 = UILabel()
        let l2 = UILabel()
        bg.addSubview(l1)
        bg.addSubview(l2)
        l1.text = "1"
        l2.text = "2"
        l1.backgroundColor = UIColor.orange
        l2.backgroundColor = UIColor.purple
        l1.frame = CGRect(x: 0, y: 0, width: ZSCREEN_WIDTH/2, height: 44)
        l2.frame = CGRect(x: ZSCREEN_WIDTH/2, y: 0, width: ZSCREEN_WIDTH/2, height: 44)
        l1.tag = 0
        l2.tag = 1
        l1.addTapViewGesture(self, action: #selector(tapSingleDid))
        l2.addTapViewGesture(self, action: #selector(tapSingleDid))
        return bg
    }
    
    override func bottomViewHeight() -> CGFloat {
        return 0
    }
    
    override func bottomView() -> UIView? {
        return nil
    }
    
    func tapSingleDid(_ ges:UITapGestureRecognizer){
        let tag = ges.view!.tag
        showViewControllerOf(tag)
    }
}
