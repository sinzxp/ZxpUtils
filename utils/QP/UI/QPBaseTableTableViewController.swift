//
//  QPBaseTableTableViewController.swift
//  QHProject
//
//  Created by quickplain on 15/12/24.
//  Copyright © 2015年 quickplain. All rights reserved.
//

import UIKit
import FlatUIKit
import DZNEmptyDataSet
import HMSegmentedControl
import SwiftyJSON

//private let imageError = UIImage(color: COLOR_CLEAR)//UIImage(named: "Cry")
//private let imageLoading = UIImage(color: COLOR_CLEAR)//UIImage(named: "Loading")

private let imageError = UIImage(named: "Cry") // UIImage(named: "Cry")
private let imageLoading = UIImage(named: "Loading")

let TIPS_LOADING = "加载中" // "加载中..."
let TIPS_LOAD_FAIL = "加载失败" // "加载失败"
let TIPS_TAP_RELOAD = "点击加载" // "点击重新加载"
let TIPS_NETWORK_EXCEPTION = "网络不是很给力,加载就失败了.."
let TIPS_CLEANING_CACHE = "正在清除缓存,请稍候"

public enum ImageType {
	case Loading
	case Error
}

extension UIViewController {
	func fixNavigationBarColor(animated: Bool) {
//        assertionFailure("lib not been imported")

		// FIXME:
//        self.navigationController?.navigationBar.translucentWith(COLOR_WHITE)
//        self.navigationController?.navigationBar.translucent = false
//
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
	}
}

//public typealias QPTableViewController = QPBaseTableViewController

open class QPTableViewController: UITableViewController {

	public var jsonInfo = JSON("")
	public var jsonArray: [JSON] = []

	open func addFooter() {
		self.tableView.addRefreshFooter(target: self, action: Selector("requestMore"))
 	}

	public var controllerInfo = NSDictionary()

	/// 推过来之前的vc
	public var pushedViewController: UIViewController?

	public var page = 1
    var shouldShowEmptyStatus: Bool = true
    var statusText = TIPS_LOADING
    var statusDesciption = TIPS_TAP_RELOAD
    var statusImage = imageLoading

	public var shouldHideNavigationBar: Bool = false

	/// 是否每次进入页面都请求服务器
	public var alwaysRequest = false

	/// tableview header segment
	public var segmentTitles = ["商会活动", "我的活动"] {
		didSet {
			self.navigationItem.titleView = initSegmentView()
		}
	}
	  
    var segment: HMSegmentedControl!

	/// 浮动在vc上的view
	public let floatView = QPFloatView()

	public func updateFloatViewFrame() {
         floatView.frame = CGRect(x:0, y:self.tableView.contentOffset.y, width:view.width,height: view.height)
	}

	open override func request() {
		super.request()
	}
    
    open override func requestMore() {
        super.requestMore()
    }

	open override func viewWillAppear(_ animated: Bool) {

		// IQKeyboardManager.sharedManager().enable = false
		// IQKeyboardManager.sharedManager().enableAutoToolbar = false

		if shouldHideNavigationBar {
 			self.navigationController?.setNavigationBarHidden(true, animated: animated)
		} else {

			fixNavigationBarColor(animated: animated)
		}
		super.viewWillAppear(animated)
		if alwaysRequest {
			request()
		}
	}

	override open func viewDidAppear(_ animated: Bool) {
		updateFloatViewFrame()
		super.viewDidAppear(animated)
	}

	open override func viewWillDisappear(_ animated: Bool) {
		if shouldHideNavigationBar {
			self.navigationController?.setNavigationBarHidden(false, animated: animated)
//		 self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)

		}
		super.viewWillDisappear(animated)
	}
 
	public func load() {
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(floatView)
		self.tableView.emptyDataSetSource = self as! DZNEmptyDataSetSource;
		self.tableView.emptyDataSetDelegate = self as! DZNEmptyDataSetDelegate;
		self.tableView.clearExtraLines()
//		self.setBackTitle("")
		if !alwaysRequest {
			request()
		}
		load()
		updateFloatViewFrame()
		self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
 	}

    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
//	override public func preferredStatusBarStyle() -> UIStatusBarStyle {
//		return UIStatusBarStyle.lightContent
//	}

	open func addRefreshHeader(target: AnyObject!, action: Selector) {
		self.tableView.addRefreshHeader(target: target, action: action)
	}

	open func addRefreshFooter(target: AnyObject!, action: Selector) {
		self.tableView.addRefreshFooter(target: target, action: action)
	}
 
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	open func reloadData() {
		self.tableView.reloadData()
	}

	open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// self.view.endEditing(true)
//		super.scrollViewDidScroll(scrollView)
        floatView.frame = CGRect(x:0, y:scrollView.contentOffset.y,width: view.width,height: view.height)
		scrollView.bringSubview(toFront: floatView)
	}
 
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
		let cell = cellForRow(atIndexPath: indexPath)
		if let qpCell = cell as? QPTableViewCell {
//			qpCell.setup()
			qpCell.rootViewController = self
			qpCell.indexPath = indexPath
			smoothUpdate(cell: qpCell, indexPath: indexPath)
			return qpCell
		}
		smoothUpdate(cell: cell, indexPath: indexPath)
		return cellForRow(atIndexPath: indexPath)
	}

	/**
     平滑的更新cell
     
     - parameter cell:      要更新的cell
     - parameter indexPath: NSIndexPath
     */
	open func smoothUpdate(cell: UITableViewCell, indexPath: IndexPath) {
	}

	open func smoothUpdate(cell: UITableViewCell, indexPath: IndexPath, section: Int, row: Int) {
	}

	/**
     平滑的更新cell
     前提是要先实现smoothUpdate,在这个方法里面实现cell内容的设置.✨
     强烈推荐使用,不会导致页面跳动.不过稍微麻烦一点点
     待测试
     
     - parameter indexPath: NSIndexPath
     */
	open func smoothReload(indexPath: IndexPath) {
		if let cell = self.tableView.cellForRow(at: indexPath as IndexPath) {
			smoothUpdate(cell: cell, indexPath: indexPath)
			smoothUpdate(cell: cell, indexPath: indexPath, section: indexPath.section, row: indexPath.row)
		}
	}
	/**
	 新版版使用这个方法加载cell

	 - parameter indexPath: indexPath

	 - returns: UITableViewCell
	 */
	open func cellForRow(atIndexPath indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
 
    open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
    
    open func customSegment(segment: HMSegmentedControl) -> HMSegmentedControl {
        return segment
    }
    
    func initSegmentView() -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width:190, height:44))
        let selectionViewSelectedColor = UIColor.white
        let selectionViewDeselectedColor = UIColor(fromHexCode: "#fad5a2")
        let selectionViewFont = FONT_TITLE
        
        if segment == nil {
            segment = HMSegmentedControl(frame: CGRect(x:5,y: 10,width: 180,height: 28))
        }
        segment.backgroundColor = UIColor.clear
        segment.sectionTitles = segmentTitles
        
        segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segment.selectionIndicatorColor = selectionViewSelectedColor
        segment.selectionIndicatorHeight = 1
        segment.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segment.verticalDividerWidth = 0
        segment.isVerticalDividerEnabled = true
        segment.verticalDividerColor = UIColor(fromHexCode: "#DFE1E3")
        
        segment.titleTextAttributes = [NSFontAttributeName: selectionViewFont, NSForegroundColorAttributeName: selectionViewDeselectedColor!]
        segment.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe
        
        segment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: selectionViewSelectedColor, NSFontAttributeName: selectionViewFont]

        segment.addTarget(self, action: #selector(segmentedControlChangedValue), for: UIControlEvents.valueChanged)
        segment = customSegment(segment: segment)
        view.addSubview(segment)
        
        return view
    }
    
    open func segmentedControlChangedValue(control: HMSegmentedControl) {
        if control.selectedSegmentIndex == 0 {
        }
        
        onSegmentChanged(index: control.selectedSegmentIndex)
    }
    
    open func onSegmentChanged(index: Int) {
    }
}

extension QPTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	open func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return EmptyLoadingImage()
	}

	open func EmptyErrorImage() -> UIImage {
		return UIImage.fromColor()
	}

	open func EmptyLoadingImage() -> UIImage {
		return UIImage.fromColor()
	}

    open func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let att = [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor.lightGray]
        return NSAttributedString(string: statusText, attributes: att)
//        return NSAttributedString(string: statusText, attributes: att)
    }

	open func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		let att = [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor.lightGray]
		return NSAttributedString(string: statusDesciption, attributes: att)
	}

	open func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
		return shouldShowEmptyStatus
	}

	open func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
		request()
	}

	open func setTableViewEmptyStatus(tableView: UITableView, title: String, description: String?, imageType: ImageType?) {
	}

	open func setTableViewEmptyStatus(title: String, description: String?, imageType: ImageType?) {
		if description == nil {
			statusDesciption = ""
		} else {
			statusDesciption = description!
		}

		if imageType != nil {
			switch imageType! {
			case .Error:
				statusImage = EmptyErrorImage()
			case .Loading:
				statusImage = EmptyLoadingImage()
				// default:
				// statusImage = imageLoading
			}
		}

		statusText = title
		self.tableView.reloadEmptyDataSet()
	}

	/**
	 隐藏空页面
	 */
	open func hideTableViewEmptyStatus() {
		shouldShowEmptyStatus = false
		self.tableView.reloadEmptyDataSet()
	}

	/**
	 显示空页面
	 */
	open func showTableViewEmptyStatus() {
		shouldShowEmptyStatus = true
		self.tableView.reloadEmptyDataSet()
	}

	/**
	 没有数据
	 */
	open func tableViewNoData() {
		setTableViewEmptyStatus(title: "没有数据", description: nil, imageType: ImageType.Loading)
		self.tableView.hideHeader()
		self.tableView.hideFooter()
	}

	/**
	 加载中
	 */
	open func tableViewLoading() {
		setTableViewEmptyStatus(title: TIPS_LOADING, description: nil, imageType: ImageType.Loading)
		self.tableView.startLoadData()
	}

	/**
	 加载失败
	 */
	open func tableViewLoadFail() {
		statusImage = EmptyErrorImage()
		setTableViewEmptyStatus(title: TIPS_LOAD_FAIL, description: TIPS_TAP_RELOAD, imageType: ImageType.Error)
		self.tableView.noticeNoMoreData()
	}

	/**
	 网络错误
	 */
	open func tableViewNetworkException() {
		setTableViewEmptyStatus(title: TIPS_NETWORK_EXCEPTION, description: TIPS_TAP_RELOAD, imageType: ImageType.Error)
		self.tableView.noticeNoMoreData()
	}

	open func offset(forEmptyDataSet scrollView: UIScrollView!) -> CGPoint {
        return CGPoint(x: 0, y: -30)
	}

	open func onSubmit() {
	}
}

public extension UITableViewController {
	public func registerTableViewCell(nibName: String, bundle: Bundle?, forCellReuseIdentifier: String) {
		self.tableView.registerTableViewCell(nibName: nibName, bundle: bundle, forCellReuseIdentifier: forCellReuseIdentifier)
	}

	public func registerTableViewCell(nibName: String, bundle: Bundle?) {
		self.tableView.registerTableViewCell(nibName: nibName, bundle: bundle, forCellReuseIdentifier: nibName)
	}

	public func registerTableViewCell(nibName: String) {
		self.tableView.registerTableViewCell(nibName: nibName, bundle: nil, forCellReuseIdentifier: nibName)
	}
}

public extension QPTableViewController {

	
}

public extension UITableView {
	/**
     重新刷新数据,防止tableview 乱跳
     !!!!有待测试
     */
	public func reloadDateWithoutScroll() {
		let inset = self.contentOffset
		self.reloadData()
		self.layoutIfNeeded()
		self.setContentOffset(inset, animated: false)
	}
}



public extension UITableView {
	public func clearExtraLines() {
		let size = CGRect.zero
		self.tableFooterView = UIView(frame: size)
	}

    public func setInsetsTop(_ top: CGFloat) {
        let insets = UIEdgeInsets(top: top, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
        setInsets(insets: insets)
    }
    
	public func setInsetsTop(top: CGFloat) {

		let insets = UIEdgeInsets(top: top, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
		setInsets(insets: insets)
	}

	public func setInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
		let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
		setInsets(insets: insets)
	}

	/**
	 修正顶栏位置

	 - parameter insets: top: 0, left: 0, bottom: 0, right: 0
	 */
	public func setInsets(insets: UIEdgeInsets) {
		self.contentInset = insets;
		self.scrollIndicatorInsets = insets;
	}
}

public extension UITableView {
	public func reloadIndexPath(indexPath: IndexPath) {
        DispatchQueue.main.async {
			self.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
		}
	}

	public func reloadVisibleData() {
        
		if let indexPaths = self.indexPathsForVisibleRows {
            DispatchQueue.main.async {
                self.reloadRows(at: indexPaths, with: UITableViewRowAnimation.none)
            }
		}
	}
}

public extension Int {
	public mutating func pageReset() {
		self = 1
	}
}

//----for xjw

public extension QPTableViewController {
	func requestPage() -> Int {
		return QPHttpUtils.pageSize()
	}
	/**
     处理下啦刷新状态,包含reloadData
     
     ********* view did load ***********
     
     self.tableView.addRefreshFooter(self, action: #selector(UIViewController.requestMore))
     
     ********* http ***********
     
     let param = ["pageNow": page, "pageSize": pageCount]
     
     ********* requetst ***********
     
     page = 1
     
     self.data = response.arrayValue
     self.setupRequest(self.data)
     
     self.jsonArray = response.list()
     self.jsonInfo = response
     self.setupRequest(self.jsonArray)

     self.showNetworkException()

     ********* more ***********
     
     page + 1
      self.view.hideAllHUD()
     let array = response.arrayValue
     for item in array {
     self.data.append(item)
     }
     self.addJSONArray(response, source: self.data)
     
     
     self.view.hideAllHUD()
     let array = response.list()
     for item in array {
     self.jsonArray.append(item)
     }
     self.addJSONArray(response, source: self.jsonArray)
     
     
     
     self.showNetworkException()
     
     
     - parameter response: response
     - parameter source:   下啦刷新原数据
     
     
     - parameter source: 下啦刷新原数据
     */
	public func setupRequest(source: [JSON]) {
		self.reloadData()
		self.page = 1
		setupFooterInfo(source: source)
		if source.count == 0 {
			self.tableViewNoData()
		}
	}

	public func setupFooterInfo(source: [JSON]) -> Bool {
		let data = source
		let count = data.count
		let limit = requestPage()
//		log.verbose("count:\(count) \(limit)")
		self.tableView.endRefreshFooter()
		var flag = true
		if count == 0 {
			self.tableView.hideFooter()
			flag = false
		} else if count < limit {
//			log.verbose("count: \(count) 不足加载更多")
			self.tableView.hideFooter()
		} else {
			self.tableView.showFooter()
		}
		return flag
	}

	/**
     下啦加载更多
     page + 1
     
     self.view.hideAllHUD()
     let array = response.arrayValue
     for item in array {
     self.data.append(item)
     }
     self.addJSONArray(response, source: self.data)
     
     self.showNetworkException()
     
     
     - parameter response: response
     - parameter source:   下啦刷新原数据
     */
	public func addJSONArray(response: JSON, source: [JSON]) {
		let array = response.arrayValue
		self.reloadData()
		let flag = setupFooterInfo(source: array)
		if flag {
			self.page += 1
		} else {
		}
	}
}

//----for xjw

