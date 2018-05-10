//
//  QPAlertUtils.swift
//  CJWUtilsS
//
//  Created by Frank on 2/27/16.
//  Copyright © 2016 cen. All rights reserved.
//

import UIKit

public class QPAlertUtils: NSObject {
	public typealias QPAlertUtilsBlock = (_ index: Int) -> ()

	public class func showSelection(viewcontroller: UIViewController, title: String, message: String, titles: [String], block: @escaping QPAlertUtilsBlock) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
		for actionTitle in titles {
			let alertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default) { (action) -> Void in
				if let index = titles.index(of: actionTitle) {
					block(index)
				}
			}
			alert.addAction(alertAction)
		}

		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) -> Void in
		}

		alert.addAction(cancel)
		viewcontroller.present(alert, animated: true) { () -> Void in
			//
		}
	}
}
