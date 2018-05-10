//
//  GZAlertActionUtils.swift
//  QHProject
//
//  Created by quickplain on 15/12/24.
//  Copyright © 2015年 quickplain. All rights reserved.
//

import UIKit

public class QPAlertActionUtils: NSObject {
}

public class CJWDate2: NSDate {
	public class func testing() {
		print("test CJWDate", terminator: "")
	}
}

public extension UIViewController {
	typealias QPAlertActionControllerInputBlock = (_ text: String) -> ()

	public func showInputAlert(title: String, message: String, inputedText: String?, keyboardType: UIKeyboardType, placeholder: String, block: @escaping QPAlertActionControllerInputBlock) {

		let actionSheet = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
		let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (action) -> Void in
			let tf = actionSheet.textFields?.first
			tf?.resignFirstResponder()
			tf?.keyboardType = keyboardType
			if let text = tf?.text {
				if text != "" {
					block(text)
				}
			}
		}

		actionSheet.addTextField { (textField) -> Void in
			textField.placeholder = placeholder
			if let input = inputedText {
				if input != "" {
					textField.text = input
				}
			}
            
		}

		actionSheet.addAction(cancelAction)
		actionSheet.addAction(comfirmAction)
        DispatchQueue.main.async {
             self.present(actionSheet, animated: true) { () -> Void in
            }
        }
	}

	public func showInputAlert(title: String, message: String, inputedText: String?, placeholder: String, block: @escaping QPAlertActionControllerInputBlock) {
		showInputAlert(title: title, message: message, inputedText: inputedText, keyboardType: UIKeyboardType.default, placeholder: placeholder, block: block)
	}

	public func showConfirmAlert(title: String, message: String, confirm: @escaping QPNormalBlock) {
		let actionSheet = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

		let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (action) -> Void in
			confirm()
		}
		actionSheet.addAction(comfirmAction)
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true) { () -> Void in
            }
        }
	}

	public func showConfirmAlert(title: String, message: String, confirm: @escaping QPNormalBlock, cancel: @escaping QPNormalBlock) {
		let actionSheet = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) -> Void in
			cancel()
		}
		let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (action) -> Void in
			confirm()
		}
		actionSheet.addAction(cancelAction)
		actionSheet.addAction(comfirmAction)
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true) { () -> Void in
            }
        }
	}

	typealias GZActionSheetBlock = (_ index: Int) -> ()
	public func showActionSheet(title: String, message: String, buttons: Array<String>, block: @escaping GZActionSheetBlock) {
		let actionSheet = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
		for button in buttons {
			let index = buttons.index(of: button)!
			let action = UIAlertAction(title: button, style: UIAlertActionStyle.default) { (action) -> Void in
				block(index)
			}
			actionSheet.addAction(action)
		}
		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) -> Void in
		}
		actionSheet.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true) { () -> Void in
            }
        }
	}
}
