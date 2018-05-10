//
//  QPAlert.swift
//  CJWUtilsS
//
//  Created by Frank on 1/18/16.
//  Copyright © 2016 cen. All rights reserved.
//

import UIKit
import KLCPopup

public class QPAlert: NSObject {

    static let sharedInstance = QPAlert()


	public var pop: KLCPopup!

	public class func dismiss() {
		QPAlert.sharedInstance.dismiss()
	}

	public func dismiss() {
		pop.dismiss(true)
	}

	/**
	 文字弹窗

	 - parameter text:     显示的文字
	 - parameter duration: 显示时长,默认1s后消失
	 */
	public class func showTips(text: String, duration: TimeInterval) {
		QPAlert.sharedInstance.showTips(text: text, duration: duration)
	}

	/**
	 文字弹窗

	 - parameter text:     显示的文字
	 - parameter duration: 显示时长,默认1s后消失
	 */
	func showTips(text: String, duration: TimeInterval) {

		let www = SCREEN_WIDTH * 0.72
		let hhh = SCREEN_HEIGHT * 0.167916042

        let vvv = UIView(frame: CGRect(x:0, y:0,width: www, height:hhh))
		vvv.backgroundColor = UIColor.white
		vvv.layer.cornerRadius = 10

		let textLabel = UILabel()
		textLabel.numberOfLines = 0
		vvv.addSubview(textLabel)

		textLabel.alignTop("0", leading: "0", bottom: "0", trailing: "0", toView: vvv)
		textLabel.text = text
		textLabel.textAlignment = NSTextAlignment.center

		if self.pop != nil {
			if self.pop.isBeingDismissed || self.pop.isBeingShown {
				return
			}
		}
		let pop = KLCPopup(contentView: vvv, showType: KLCPopupShowType.growIn, dismissType: KLCPopupDismissType.bounceOut, maskType: KLCPopupMaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)

		pop?.contentView.layer.cornerRadius = 20
		pop?.show()
		self.pop = pop

		excute(timeDelay: duration) { () -> () in
			self.dismiss()
		}
	}
}

public extension NSObject {
	/**
	 文字弹窗

	 - parameter text:     显示的文字
	 - parameter duration: 显示时长,默认1s后消失
	 */
	public func showText(text: String, duration: TimeInterval = 1) {
		QPAlert.showTips(text: text, duration: duration)
	}
    
    public func showText(_ text: String, duration: TimeInterval = 1) {
        QPAlert.showTips(text: text, duration: duration)
    }
}
