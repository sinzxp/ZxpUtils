//
//  ZXPDatePickerDialog.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/7.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import QuartzCore

class ZXPDatePickerDialog: UIView {
    
    typealias DatePickerCallback = (_ date: Date) -> Void
    
    /* Consts */
    fileprivate let kDatePickerDialogDefaultButtonHeight: CGFloat = 50
    fileprivate let kDatePickerDialogDefaultButtonSpacerHeight: CGFloat = 1
    fileprivate let kDatePickerDialogCornerRadius: CGFloat = 7
    fileprivate let kDatePickerDialogDoneButtonTag: Int = 1
    
    /* Views */
    fileprivate var dialogView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var datePicker: UIDatePicker!
    fileprivate var cancelButton: UIButton!
    fileprivate var doneButton: UIButton!
    
    /* Vars */
    fileprivate var defaultDate: Date?
    fileprivate var datePickerMode: UIDatePickerMode?
    fileprivate var callback: DatePickerCallback?
    
    /// 选择过去的时间
    var enableHistorySelection : Bool = false {
        didSet {
            if enableHistorySelection {
            } else {
                self.datePicker.minimumDate = Date()
            }
        }
    }
    
    /* Overrides */
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.dialogView = createContainerView()
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.layer.opacity = 0
        self.addSubview(self.dialogView!)
    }
    
//    func deviceOrientationDidChange(_ notification: Notification) {
//        close()
//    }
    
    func show(_ title: String, doneButtonTitle: String = "Done", cancelButtonTitle: String = "Cancel", defaultDate: Date = Date(), datePickerMode: UIDatePickerMode = .dateAndTime, callback: @escaping DatePickerCallback) {
        self.titleLabel.text = title
        self.doneButton.setTitle(doneButtonTitle, for: UIControlState())
        self.cancelButton.setTitle(cancelButtonTitle, for: UIControlState())
        self.datePickerMode = datePickerMode
        self.callback = callback
        self.defaultDate = defaultDate
        self.datePicker.datePickerMode = self.datePickerMode ?? .date
        self.datePicker.date = self.defaultDate ?? Date()
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        ///旋转监听?
//        NotificationCenter.default.addObserver(self, selector: #selector(DatePickerDialog.deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        self.dialogView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.7,y: 0.7))
        UIView.animate(withDuration: 0.2, animations: {
            self.dialogView.layer.setAffineTransform(CGAffineTransform.identity)
            self.layer.opacity = 1
        })
    }
    
    @objc fileprivate func close() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dialogView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.7,y: 0.7))
            self.layer.opacity = 0
        }) { bool in
            for v in self.subviews {
                v.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    
    fileprivate func createContainerView() -> UIView {
        
        let view = UIView()
        view.layer.cornerRadius = kDatePickerDialogCornerRadius
        view.frame.origin = CGPoint(x: self.bounds.size.width / 2 - 150, y: self.bounds.size.height / 2 - 115)
        view.frame.size = CGSize(width: 300, height: 230)
        view.backgroundColor = UIColor.white
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 30, width: 300, height: 150))
//        self.datePicker.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
//        self.datePicker.frame.size.width = 300
        view.addSubview(self.datePicker)
        
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 280, height: 30))
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(self.titleLabel)
        
        addButtonsToView(view)
        
        return view
    }
    
    fileprivate func addButtonsToView(_ container: UIView) {
        
        let buttonWidth = container.bounds.size.width / 2
        
        let lineView = UIView(frame: CGRect(x: 0, y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight - kDatePickerDialogDefaultButtonSpacerHeight, width: container.bounds.size.width, height: kDatePickerDialogDefaultButtonSpacerHeight))
        lineView.backgroundColor = UIColor(red: 198 / 255, green: 198 / 255, blue: 198 / 255, alpha: 1)
        container.addSubview(lineView)
        
        self.cancelButton = UIButton(type: UIButtonType.custom)
        self.cancelButton.frame = CGRect( x: 0, y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight, width: buttonWidth, height: kDatePickerDialogDefaultButtonHeight)
        self.cancelButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.cancelButton.setTitleColor(UIColor.appleBlue, for: UIControlState())
        self.cancelButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.cancelButton.addTarget(self, action: #selector(ZXPDatePickerDialog.close), for: UIControlEvents.touchUpInside)
        container.addSubview(self.cancelButton)
        
        self.doneButton = UIButton(type: UIButtonType.custom) as UIButton
        self.doneButton.frame = CGRect( x: buttonWidth, y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight, width: buttonWidth,height: kDatePickerDialogDefaultButtonHeight)
        self.doneButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.doneButton.setTitleColor(UIColor.appleBlue, for: UIControlState())
        self.doneButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.doneButton.addTarget(self, action: #selector(ZXPDatePickerDialog.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        container.addSubview(self.doneButton)
    }
    
    func buttonTapped(_ sender: UIButton!) {
        self.callback?(self.datePicker.date)
        close()
    }
    
}

class RCDatePicker: UIView {
    
    typealias QHDatePickerBlock = (_ date: Date) -> ()

    func show(_ title: String, mode: UIDatePickerMode, enableHistorySelection: Bool, block: @escaping QHDatePickerBlock) {
        let picker = ZXPDatePickerDialog()
        picker.enableHistorySelection = enableHistorySelection
        picker.show(title, doneButtonTitle: "确定", cancelButtonTitle: "取消", defaultDate: Date(), datePickerMode: mode) { (date) -> Void in
            block(date)
        }
    }

    func show(_ title: String, mode: UIDatePickerMode, block: @escaping QHDatePickerBlock) {
        show(title, mode: mode, enableHistorySelection: false, block: block)
    }

    func show(_ title: String, block: @escaping QHDatePickerBlock) {
        show(title, mode: .date, block: block)
    }
}


