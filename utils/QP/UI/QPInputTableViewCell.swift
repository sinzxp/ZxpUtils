//
//  QPInputTableViewCell.swift
//  CJWUtilsS
//
//  Created by Frank on 19/03/2017.
//  Copyright © 2017 cen. All rights reserved.
//

import UIKit

public typealias QPInputTableViewCellBlock = (_ text: String) -> ()

public class QPInputTableViewCell: QPTableViewCell, UITextFieldDelegate {

	public let tipsLabel = QPTipsLabel()
	public let textField = UITextField()

	var block: QPInputTableViewCellBlock?

	public override func setupViews(view: UIView) {
		super.setupViews(view: view)
		view.addSubview(tipsLabel)
		view.addSubview(textField)
		textField.clearButtonMode = UITextFieldViewMode.whileEditing
		tipsLabel.font = UIFont.fontNormal()
		textField.font = UIFont.fontNormal()
		tipsLabel.textColor = UIColor.darkGray
		textField.delegate = self
		textField.placeholder = "请输入"
	}

	public override func setupConstrains(view: UIView) {
		super.setupConstrains(view: view)

		tipsLabel.leadingAlign(view: view, predicate: "16")
		tipsLabel.topAlign(view: view, predicate: "16")
		tipsLabel.bottomAlign(view: view, predicate: "-16")
		tipsLabel.centerY(view: view)

		textField.leadingAlign(view: view, predicate: "100")
//        textField.leadingConstrain(tipsLabel, predicate: ">=16")
		textField.trailingAlign(view: view)
		textField.centerY(view: view)
		textField.trailingAlign(view: view)
	}

	public func onTextChanged(block: @escaping QPInputTableViewCellBlock) {
		self.block = block
	}

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let text = QPUtils.getTextFiedlChangedText(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
		block?(text)
		return true
	}

	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		block?("")
		return true
	}
}

public class QPInputNumberTableViewCell: QPInputTableViewCell {
	public override func setupViews(view: UIView) {
		super.setupViews(view: view)
		textField.keyboardType = UIKeyboardType.numberPad
	}
}

public class QPInputMobileTableViewCell: QPInputTableViewCell {
	public override func setupViews(view: UIView) {
		super.setupViews(view: view)
		textField.keyboardType = UIKeyboardType.phonePad
		textField.placeholder = "请输入手机号码"
	}
}

public class QPInputPasswordTableViewCell: QPInputTableViewCell {
	public override func setupViews(view: UIView) {
		super.setupViews(view: view)
		textField.isSecureTextEntry = true
	}
}

public class QPInputVerifyCodeTableViewCell: QPInputTableViewCell2 {
	public override func setupViews(view: UIView) {
		super.setupViews(view: view)
		textField.placeholder = "请输入手机号码"
		infoLabel.text = "获取验证码"
	}
}

public class QPInputTableViewCell2: QPTableViewCell, UITextFieldDelegate {
	public let tipsLabel = QPTipsLabel()
	public let textField = UITextField()
	public let infoLabel = UILabel()
	var block: QPInputTableViewCellBlock?

	public override func setupViews(view: UIView) {
		super.setupViews(view: view)
		view.addSubview(tipsLabel)
		view.addSubview(textField)
		view.addSubview(infoLabel)
		textField.delegate = self

		textField.clearButtonMode = UITextFieldViewMode.whileEditing
		tipsLabel.font = UIFont.fontNormal()
		textField.font = UIFont.fontNormal()

		infoLabel.font = UIFont.fontSmall()
		infoLabel.textColor = UIColor.white
		infoLabel.backgroundColor = UIColor.mainColor()
		infoLabel.textAlignmentCenter()
		infoLabel.cornorRadius(radius: 5)

		tipsLabel.textColor = UIColor.darkGray
	}

	public override func setupConstrains(view: UIView) {
		super.setupConstrains(view: view)

		tipsLabel.leadingAlign(view: view, predicate: "16")
		tipsLabel.topAlign(view: view, predicate: "16")
		tipsLabel.bottomAlign(view: view, predicate: "-16")
		tipsLabel.centerY(view: view)

		textField.leadingAlign(view: view, predicate: "100")
		textField.centerY(view: view)
        textField.trailingConstrain(view: infoLabel )
 
		infoLabel.centerY(view: view)
		infoLabel.trailingAlign(view: view)
		infoLabel.widthConstrain(predicate: "100")
		infoLabel.heightConstrain(predicate: "25")
	}

	public func onTextChanged(block: @escaping QPInputTableViewCellBlock) {
		self.block = block
	}

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let text = QPUtils.getTextFiedlChangedText(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
		block?(text)
		return true
	}

	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		block?("")
		return true
	}
}

open class QPLabelTableViewCell: QPTableViewCell {

	open let tipsLabel = QPTipsLabel()
	open let titleLabel = UILabel()

	open override func setupViews(view: UIView) {
        super.setupViews(view: view)
		view.addSubview(tipsLabel)
		view.addSubview(titleLabel)
		tipsLabel.font = UIFont.fontNormal()
		titleLabel.font = UIFont.fontNormal()
		tipsLabel.textColor = UIColor.darkGray
	}

	open override func setupConstrains(view: UIView) {
		super.setupConstrains(view: view)

		titleLabel.leadingAlign(view: view, predicate: ">=100")
		titleLabel.leadingConstrain(view: tipsLabel, predicate: ">=16")
//        titleLabel.trailingAlign(view)
		titleLabel.centerY(view: view)
//        titleLabel.trailingAlign(view)

		tipsLabel.leadingAlign(view: view, predicate: "16")
		tipsLabel.topAlign(view: view, predicate: "16")
		tipsLabel.bottomAlign(view: view, predicate: "-16")
		tipsLabel.centerY(view: view)

	}
}

