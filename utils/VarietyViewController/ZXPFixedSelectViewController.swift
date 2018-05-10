//
//  ZXPFixedSelectViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/26.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import HMSegmentedControl

public class ZXPFixedSelectViewController: UIViewController {

    private var containsView = UIView()
    private var topContainsView = UIView()
    private var middleContainsView = UIView()
    private var bottomContainsView = UIView()
    
    ///选择的vc
    var oldController:UIViewController!
    ///选择的index
    var currentPage = 0
    
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
    private func middleViewHeight() -> CGFloat {
        return containsView.height - topViewHeight() - bottomViewHeight()
    }
    ///添加上边view 不用加
    private func middleView() -> UIView? {
        return nil
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
    
    private func initContainsView() {
        containsView.frame = CGRect(x: 0, y: topPading() , width: self.view.width, height: self.view.height - topPading() - bottomPading())
//        containsView.backgroundColor = UIColor.green
        self.view.addSubview(containsView)
        
//        topContainsView.backgroundColor = UIColor.alizarin()
        topContainsView.frame = CGRect(x: 0, y: 0, width: containsView.width, height: topViewHeight())
        containsView.addSubview(topContainsView)
        
//        middleContainsView.backgroundColor = UIColor.yellow
        middleContainsView.frame = CGRect(x: 0, y: topViewHeight(), width: containsView.width, height: middleViewHeight())
        containsView.addSubview(middleContainsView)
        
//        bottomContainsView.backgroundColor = UIColor.green
        bottomContainsView.frame = CGRect(x: 0, y: topViewHeight() + middleViewHeight(), width: containsView.width, height: bottomViewHeight())
        containsView.addSubview(bottomContainsView)
        
        addView()
    }
    
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

    private func initViewControllers() {
        let frame = middleContainsView.bounds
        for index in 0..<numberOfViewController() {
            let vc = addViewControllerAt(index)
            let view = vc.view!
            if index == 0 {
                middleContainsView.addSubview(view)
                oldController = vc
            }
            setViewControllerAt(vc, index: index)
            self.addChildViewController(vc)
            view.frame = frame
        }
    }
    
    public func showViewControllerOf(_ index: Int) {
        let vcs = self.childViewControllers
        if index < vcs.count {
            let tvc = vcs[index]
            if oldController != tvc {
                self.transition(from: oldController, to: tvc, duration: 0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (bool) in
                    self.currentPage = index
                    self.oldController = tvc
                })
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
class ZXPFixedSelectViewControllerCS: ZXPFixedSelectViewController {
    
    var segment: HMSegmentedControl!
    
    var sss = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfViewController() -> Int {
        return sectionTitles().count
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
    
    override func setViewControllerAt(_ vc: UIViewController, index: Int) {
        ///设置父vc才能传递数据
        if let vc = vc as? ZXPFixedSelectChildTableViewController {
            vc.rootSegment = self
        }
    }
    
    override func topViewHeight() -> CGFloat {
        return 44
    }
    
    override func topView() -> UIView? {
        return initSegmentedControl()
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
    
    override func selectIndexAndVC(_ index: Int, vc: UIViewController) {
        
    }
    
    override func selectSegmentedControlIndex(_ index: Int) {
        showViewControllerOf(index)
    }
}

extension UIViewController {
    
    ///设置segment的title
    open func sectionTitles() -> [String] {
        return ["11111","22223","33333"]
    }
    ///自定义segment
    open func customSegmentedControl(_ segment: HMSegmentedControl) -> HMSegmentedControl {
        return segment
    }
    ///SegmentedControl选择后的Index
    open func selectSegmentedControlIndex(_ index: Int) {
        
    }
    ///返回一个HMSegmentedControl
    public func initSegmentedControl() -> UIView {
        let selectionViewSelectedColor = UIColor.blue
        let selectionViewDeselectedColor = UIColor.purple
        let selectionViewFont = UIFont.systemFont(ofSize: 14)
        var segment = HMSegmentedControl(frame: CGRect(x: 0, y: 0, width: ZSCREEN_WIDTH, height: 44))
        segment.backgroundColor = UIColor.white
        segment.sectionTitles = sectionTitles()
        segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segment.selectionIndicatorColor = selectionViewSelectedColor
        segment.selectionIndicatorHeight = 3
        segment.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segment.isVerticalDividerEnabled = true
        segment.verticalDividerWidth = 0 ///间隔大小
        segment.verticalDividerColor = UIColor.purple ///间隔颜色
        segment.titleTextAttributes = [ NSForegroundColorAttributeName: selectionViewDeselectedColor,NSFontAttributeName: selectionViewFont]
        segment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: selectionViewSelectedColor, NSFontAttributeName: selectionViewFont]
        segment.addTarget(self, action: #selector(segmentedControlChangedForValue), for: UIControlEvents.valueChanged)
        segment = customSegmentedControl(segment)
        return segment
    }
    
    open func segmentedControlChangedForValue(_ control: HMSegmentedControl) {
        let index = control.selectedSegmentIndex
        selectSegmentedControlIndex(index)
        selectSegmentedControl(control)
    }
    
    open func selectSegmentedControl(_ control: HMSegmentedControl) {
        
    }
    
}

public class ZXPFixedSelectChildTableViewController: UITableViewController {
    var rootSegment: ZXPFixedSelectViewControllerCS!
}
