//
//  QPBaseTableViewCell.swift
//  QHProject
//
//  Created by quickplain on 15/12/24.
//  Copyright © 2015年 quickplain. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
//public typealias QPTableViewCell = QPBaseTableViewCell

public class QPCollectionViewCell: UICollectionViewCell {
	/// 父view controller
	public var rootViewController: UIViewController?
	/// 这个cell的indexPath
	public var indexPath: NSIndexPath?
	public var didSetupConstraints = false
	/// cell的数据
	public var cellInfo = NSDictionary()

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initCell()
	}

	/**
     为contentView添加autoLayout
     */
	func setupAutoLayout() {
		self.contentView.setToAutoLayout()
		contentView.alignLeading("0", trailing: "0", toView: self)
	}

	/**
     初始化cell
     
     - returns: nil
     */
	func initCell() {
		setupViews(view: contentView)
		setupAutoLayout()
	}

	/**
     更新Constrains
     */
	override public func updateConstraints() {

		// if !didSetupConstraints {
		// setupConstrains(contentView)
		// didSetupConstraints = true
		// }
		setupConstrains(view: contentView)

		super.updateConstraints()
	}

	/**
     构造Constrains
     
     - parameter view: cell.contentView
     */
	public func setupConstrains(view: UIView) {
	}
    
    public func setupConstrains(_ view: UIView) {
    }


	/**
     初始化cell内的view
     
     - parameter view: cell.contentView
     */
	public func setupViews(view: UIView) {
	}

	/**
     添加cell内容
     
     - parameter info: info
     */
	public func setInfo(info: NSDictionary) {
		self.cellInfo = info
		setupConstrains(view: contentView)
	}

	public func setJson(json: JSON) {
		setupConstrains(view: contentView)
	}

	public func setup() {
		self.setNeedsUpdateConstraints()
		self.updateConstraintsIfNeeded()
	}

}


 

open class QPTableViewCell: UITableViewCell{
    
    /// 父view controller
    public var rootViewController: UIViewController?
    /// 这个cell的indexPath
    public var indexPath: IndexPath?
    public var didSetupConstraints = false
    /// cell的数据
    public var cellInfo = NSDictionary()
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCell()
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCell()
    }
    
    func initCell(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setupViews(view: self.contentView)
        setupConstrains(view: self.contentView)
        setupViews(self.contentView)
        setupConstrains(self.contentView)
 
    }
    
    private func setupContentView(){
         let superview = contentView.superview!
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(superview).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    open func setInfo(info: NSDictionary) {
        self.cellInfo = info
    }
    
    open func setInfo(_ info: NSDictionary) {
        self.cellInfo = info
    }
    
    /**
     构造Constrains
     
     - parameter view: cell.contentView
     */
    open func setupConstrains(view: UIView) {
    }
    
    open func setupConstrains(_ view: UIView) {
    }
    
    /**
     初始化cell内的view
     
     - parameter view: cell.contentView
     */
    open func setupViews(view: UIView) {
    }
    
    open func setupViews(_ view: UIView) {
    }
    
    open func setup(){
    }
}



//public class QPOldBaseTableViewCell: UITableViewCell {
//
//	/// 父view controller
//	public var rootViewController: UIViewController?
//	/// 这个cell的indexPath
//	public var indexPath: NSIndexPath?
//	public var didSetupConstraints = false
//	/// cell的数据
//	public var cellInfo = NSDictionary()
//
//	required public init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		initCell()
//	}
//
//	override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//		super.init(style: style, reuseIdentifier: reuseIdentifier)
//		initCell()
//	}
//
//	/**
//	 为contentView添加autoLayout
//	 */
//	public func setupAutoLayout() {
//		self.contentView.setToAutoLayout()
////        contentView.equalConstrain2(view: self)
////		contentView.alignLeading("0", trailing: "0", toView: self)
//	}
//
//	/**
//	 初始化cell
//
//	 - returns: nil
//	 */
//	public func initCell() {
//		setupViews(view: contentView)
//		setupAutoLayout()
//		self.selectionStyle = UITableViewCellSelectionStyle.none
//	}
//
//	/**
//	 更新Constrains
//	 */
//	override public func updateConstraints() {
//
//		// if !didSetupConstraints {
//		// setupConstrains(contentView)
//		// didSetupConstraints = true
//		// }
//        super.updateConstraints()
//
//		setupConstrains(view: contentView)
//
//	}
//
//	/**
//	 构造Constrains
//
//	 - parameter view: cell.contentView
//	 */
//	public func setupConstrains(view: UIView) {
//	}
//
//	/**
//	 初始化cell内的view
//
//	 - parameter view: cell.contentView
//	 */
//	public func setupViews(view: UIView) {
//	}
//
//	/**
//	 添加cell内容
//
//	 - parameter info: info
//	 */
//	public func setInfo(info: NSDictionary) {
//		self.cellInfo = info
//		setupConstrains(view: contentView)
//	}
//
//	public func setJson(json: JSON) {
//		setupConstrains(view: contentView)
//	}
//
//	public func setup() {
////		self.setNeedsUpdateConstraints()
////		self.updateConstraintsIfNeeded()
//        self.setNeedsLayout()
//	}
//
//}

public extension UITableView {
	public func disableSeparator() {
		separatorStyle = UITableViewCellSeparatorStyle.none
	}
}

public extension UITableViewCell {
	/**
	 隐藏分割线
	 */
	public func disableSeparator() {
		separatorInset = UIEdgeInsetsMake(0, bounds.size.width * 2, 0, 0);
	}
}

open class QPSubmitTableViewCell: QPTableViewCell {

	public let titleLabel = UILabel()

	open override func setupViews(view: UIView) {
		super.setupViews(view: view)
		view.addSubview(titleLabel)
		titleLabel.cornorRadius(radius: 5)
		titleLabel.backgroundColor = UIColor.mainColor()
		titleLabel.textAlignmentCenter()
		titleLabel.textColor = UIColor.white
        
		titleLabel.font = UIFont.fontNormal()
		self.disableSeparator()
	}

	open override func setupConstrains(view: UIView) {
		super.setupConstrains(view: view)
		titleLabel.leadingAlign(view: view)
		titleLabel.trailingAlign(view: view)
		titleLabel.bottomAlign(view: view)
		titleLabel.topAlign(view: view)
		titleLabel.heightConstrain(predicate: "44")
	}

}

open class QPConfirmTableViewCell: QPTableViewCell {
	public let button = UIButton()
	private let label = UILabel()

	override open func setupViews(view: UIView) {
		super.setupViews(view: view)

		view.addSubview(button)
		view.addSubview(label)

		button.backgroundColor = UIColor.peterRiver()
		button.setTitleColor(UIColor.white, for: UIControlState.normal)
		backgroundColorClear()

		separatorInset = UIEdgeInsetsMake(0, bounds.size.width * 2, 0, 0);

	}

	override open func setupConstrains(view: UIView) {
		super.setupConstrains(view: view)

		label.heightConstrain(predicate: "40")
		label.leadingAlign(view: view, predicate: "16")
		label.topAlign(view: view, predicate: "20")
		label.trailingAlign(view: view, predicate: "-16")
		label.bottomAlign(view: view, predicate: "-4")

		button.heightConstrain(predicate: "40")
		button.leadingAlign(view: view, predicate: "16")
		button.topAlign(view: view, predicate: "20")
		button.trailingAlign(view: view, predicate: "-16")
		button.bottomAlign(view: view, predicate: "-4")

	}

}

// MARK: - QPNormalTableViewCell
open class QPNormalTableViewCell: UITableViewCell {
	/// 父view controller
	public var rootViewController: UIViewController?
	/// 这个cell的indexPath
	public var indexPath: NSIndexPath?
	public var didSetupConstraints = false
	/// cell的数据
	public var cellInfo = NSDictionary()

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initCell()
	}

	/**
     为contentView添加autoLayout
     */
	func setupAutoLayout() {
		self.contentView.setToAutoLayout()
		contentView.alignLeading("0", trailing: "0", toView: self)
	}

	override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		initCell()
	}

	/**
     初始化cell
     
     - returns: nil
     */
	func initCell() {
		setupViews(view: contentView)
        setupAutoLayout()
		self.selectionStyle = UITableViewCellSelectionStyle.none
	}

	/**
     更新Constrains
     */
	override open func updateConstraints() {

		// if !didSetupConstraints {
		// setupConstrains(contentView)
		// didSetupConstraints = true
		// }
		setupConstrains(view: contentView)

		super.updateConstraints()
	}

	/**
     构造Constrains
     
     - parameter view: cell.contentView
     */
	open func setupConstrains(view: UIView) {
	}

	/**
     初始化cell内的view
     
     - parameter view: cell.contentView
     */
	open func setupViews(view: UIView) {
	}

	/**
     添加cell内容
     
     - parameter info: info
     */
	open func setInfo(info: NSDictionary) {
		self.cellInfo = info
		setupConstrains(view: contentView)
	}

	open func setJson(json: JSON) {
		setupConstrains(view: contentView)
	}

	open func setup() {
		self.setNeedsUpdateConstraints()
		self.updateConstraintsIfNeeded()
	}
}

public extension UITableView {
	public func registerQPInputCell() {
		self.register(QPInputTableViewCell.self, forCellReuseIdentifier: "QPInputTableViewCell")
	}

	public func registerQPNumberCell() {
		self.register(QPInputNumberTableViewCell.self, forCellReuseIdentifier: "QPInputNumberTableViewCell")
	}

	public func registerQPInputMobileCell() {
		self.register(QPInputMobileTableViewCell.self, forCellReuseIdentifier: "QPInputMobileTableViewCell")
	}

	public func registerQPInputPasswordCell() {
		self.register(QPInputPasswordTableViewCell.self, forCellReuseIdentifier: "QPInputPasswordTableViewCell")
	}

	public func registerQPInputCell2() {
		self.register(QPInputTableViewCell2.self, forCellReuseIdentifier: "QPInputTableViewCell2")
	}

	public func registerQPLabelCell() {
		self.register(QPLabelTableViewCell.self, forCellReuseIdentifier: "QPLabelTableViewCell")
	}
}

