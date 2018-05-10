
//
//  QPGridTableViewCell.swift
//  CJWUtilsS
//
//  Created by Frank on 7/18/16.
//  Copyright © 2016 cen. All rights reserved.
//

import UIKit
@objc
public protocol QPGridTableViewCellDelegate {
    func viewAt(cell: QPTableViewCell, index: Int) -> UIView
    func numberOfColumn(cell: QPTableViewCell) -> Int
    /**
     如果不固定grid的数量返回0!!!!!!
     
     - returns: grids的数量
     */
    func numberOfItem(cell: QPTableViewCell) -> Int
    @objc optional func heightPredicateForView(cell: QPTableViewCell) -> String?
    @objc optional func gridPadding(cell: QPTableViewCell) -> Int
}

//extension QPGridTableViewCell: QPGridTableViewCellDelegate {
//	public func buttonAt(index: Int) -> UIButton {
//		return UIButton()
//	}
//
//	public func numberOfRow() -> Int {
//		return 0
//	}
//
//	public func numberOfColumn() -> Int {
//		return 0
//	}
//}

open class QPGridTableViewCell: QPTableViewCell,QPGridTableViewCellDelegate {

	public var delegate: QPGridTableViewCellDelegate?
	public var customViews: [UIView] = []
	var grids: [UIView] = []

	private var row = 0
	public var column = 0
	private var count = 0

	private var privateRowCount = 0;

	let gridContainerView = UIView()

	public convenience init(rowCount: Int, delegate: QPGridTableViewCellDelegate, tag: Int) {
		self.init()
		self.tag = tag
		self.delegate = delegate
		privateRowCount = rowCount
		grids = []
		for sv in contentView.subviews {
			sv.removeFromSuperview()
		}
		initCell()
	}

	public convenience init(rowCount: Int, delegate: QPGridTableViewCellDelegate) {
		self.init()
		self.delegate = delegate
		privateRowCount = rowCount
		grids = []
		for sv in contentView.subviews {
			sv.removeFromSuperview()
		}
		initCell()
	}

	override open func setupViews(view: UIView) {
		super.setupViews(view: view)
		if self.delegate == nil {
			self.delegate = self
		}
		column = delegate?.numberOfColumn(cell: self) ?? 0

		var itemCount = 0
		if privateRowCount > 0 {
			itemCount = privateRowCount
		} else {
			itemCount = delegate?.numberOfItem(cell: self) ?? 0
		}

		count = itemCount
		self.backgroundColor = UIColor.white

		view.addSubview(gridContainerView)
		if count == 0 {
			return
		}
		for index in 0 ... count - 1 {

			let grid = UIView()
			grids.append(grid)
			gridContainerView.addSubview(grid)

			let customView = delegate?.viewAt(cell: self, index: index) ?? UIView()
			customView.tag = index
			customViews.append(customView)
			grid.addSubview(customView)
		}
	}

	override open func layoutSubviews() {
		super.layoutSubviews()
	}

	open func addTarget(target: AnyObject?, action: Selector) {
		for customView in customViews {
			customView.addTapGesture(target: target, action: action)
		}
	}

	override open func setupConstrains(view: UIView) {
		super.setupConstrains(view: view)

		let tmpPadding = delegate?.gridPadding?(cell: self) ?? 0
		let padding = tmpPadding == 0 ? 0 : tmpPadding / 2

        gridContainerView.topAlign(view: view, predicate: "\(padding)")
		gridContainerView.bottomAlign(view: view, predicate: "-\(padding)")
		gridContainerView.leadingAlign(view: view, predicate: "\(padding)")
		gridContainerView.trailingAlign(view: view, predicate: "-\(padding)")

        if customViews.isEmpty {
            return
        }
        
		var horizanReferenceView = customViews.first!
		var verticalReferenceView = customViews.first!

		let wwwScale: CGFloat = CGFloat(1) / CGFloat(column)

		let view = gridContainerView

		for grid in grids {
			let index = grids.index(of: grid)!

			let customView = customViews[index]

			let scale: CGFloat = CGFloat(1) / CGFloat(column * 2)
			let columnIndex = index % column
			let indexFloat: CGFloat = CGFloat(columnIndex + 1) * 2 - 1
			let predicateX: CGFloat = indexFloat * scale * 2

			if index == 0 {
				grid.topAlign(view: view, predicate: "0")
				horizanReferenceView = grid
				verticalReferenceView = grid
				if grids.count == 1 {
					grid.bottomAlign(view: view, predicate: "0")
				}
			} else {
				if index % column == 0 {
					grid.topConstrain(view: verticalReferenceView, predicate: "0")
					verticalReferenceView = grid
					horizanReferenceView = grid
				} else {
					grid.centerY(view: horizanReferenceView)
					horizanReferenceView = grid
				}

				if index == count - 1 {
					grid.bottomAlign(view: view, predicate: "0")
				}
			}

			grid.centerX(view: grid.superview!, predicate: "*\(predicateX)")

            grid.width(view: grid.superview!, predicate: "*\(wwwScale)")
			if index != 0 {
                grid.width(view: horizanReferenceView)
			}
			if let predicate = delegate?.heightPredicateForView?(cell: self) {
				grid.heightConstrain(predicate: predicate)
			} else {
				grid.aspectRatio()
			}

			let customViewSuperView = customView.superview!
			customView.leadingAlign(view: customViewSuperView, predicate: "\(padding)")
			customView.trailingAlign(view: customViewSuperView, predicate: "-\(padding)")
			customView.topAlign(view: customViewSuperView, predicate: "\(padding)")
			customView.bottomAlign(view: customViewSuperView, predicate: "-\(padding)")

		}
	}
    
    open func gridPadding(cell: QPTableViewCell) -> Int {
        return 8
    }
    
    open func numberOfItem(cell: QPTableViewCell) -> Int {
        return 0
    }
    
    open func numberOfColumn(cell: QPTableViewCell) -> Int {
        return 4
    }
    
    open func viewAt(cell: QPTableViewCell, index: Int) -> UIView {
        let label = UILabel()
        label.text = "label \(index)"
        label.textAlignmentCenter()
        return label
    }
}

