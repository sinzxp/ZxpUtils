//
//  ZXPDatePickerDialog.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/7.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import QuartzCore

///时间选择器
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
    
    //显示位置
    var positionBottom = false
    
    /* Overrides */
    init(_ posBottom:Bool = false) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.positionBottom = posBottom
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
        
        if positionBottom {
            self.dialogView.frame.origin.y = self.bounds.size.height
            UIView.animate(withDuration: 0.2, animations: {
                self.dialogView.frame.origin.y = self.bounds.size.height - 230
                self.layer.opacity = 1
            })
        } else {
            self.dialogView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.7,y: 0.7))
            UIView.animate(withDuration: 0.2, animations: {
                self.dialogView.layer.setAffineTransform(CGAffineTransform.identity)
                self.layer.opacity = 1
            })
        }
    }
    
    @objc fileprivate func close() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.positionBottom {
                self.dialogView.frame.origin.y = self.bounds.size.height
            } else {
                self.dialogView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.7,y: 0.7))
            }
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
        view.backgroundColor = UIColor.white
        if positionBottom {
            view.frame.origin = CGPoint(x: 0, y: self.bounds.size.height - 230)
            view.frame.size = CGSize(width: self.bounds.size.width, height: 230)
            
            self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 50, width: self.bounds.size.width, height: 180))
        } else {
            view.layer.cornerRadius = kDatePickerDialogCornerRadius
            view.frame.origin = CGPoint(x: self.bounds.size.width / 2 - 150, y: self.bounds.size.height / 2 - 115)
            view.frame.size = CGSize(width: 300, height: 230)
            
            self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 30, width: 300, height: 150))
        }

//        self.datePicker.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
//        self.datePicker.frame.size.width = 300
        view.addSubview(self.datePicker)
        
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: view.frame.size.width, height: 30))
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(self.titleLabel)

        addButtonsToView(view)
        
        return view
    }
    
    fileprivate func addButtonsToView(_ container: UIView) {
        
        let lineView = UIView()
        if positionBottom {
            lineView.frame = CGRect(x: 0, y: kDatePickerDialogDefaultButtonHeight , width: container.bounds.size.width, height: kDatePickerDialogDefaultButtonSpacerHeight)
        } else {
            lineView.frame = CGRect(x: 0, y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight - kDatePickerDialogDefaultButtonSpacerHeight, width: container.bounds.size.width, height: kDatePickerDialogDefaultButtonSpacerHeight)
        }
        lineView.backgroundColor = UIColor(red: 198 / 255, green: 198 / 255, blue: 198 / 255, alpha: 1)
        container.addSubview(lineView)
        
        self.cancelButton = UIButton(type: UIButtonType.custom)
        self.cancelButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.cancelButton.setTitleColor(UIColor.appleBlue, for: UIControlState())
        self.cancelButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.cancelButton.addTarget(self, action: #selector(ZXPDatePickerDialog.close), for: UIControlEvents.touchUpInside)
        container.addSubview(self.cancelButton)
        
        self.doneButton = UIButton(type: UIButtonType.custom) as UIButton
        self.doneButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.doneButton.setTitleColor(UIColor.appleBlue, for: UIControlState())
        self.doneButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.doneButton.addTarget(self, action: #selector(ZXPDatePickerDialog.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        container.addSubview(self.doneButton)
        
        if positionBottom {
            let buttonWidth = container.bounds.size.width / 7
            self.cancelButton.frame = CGRect( x: 0, y: 0, width: buttonWidth, height: kDatePickerDialogDefaultButtonHeight)
            self.doneButton.frame = CGRect( x: container.bounds.size.width - buttonWidth, y: 0, width: buttonWidth,height: kDatePickerDialogDefaultButtonHeight)
        } else {
            let buttonWidth = container.bounds.size.width / 2
            self.cancelButton.frame = CGRect( x: 0, y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight, width: buttonWidth, height: kDatePickerDialogDefaultButtonHeight)
            self.doneButton.frame = CGRect( x: buttonWidth, y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight, width: buttonWidth,height: kDatePickerDialogDefaultButtonHeight)
        }

    }
    
    func buttonTapped(_ sender: UIButton!) {
        self.callback?(self.datePicker.date)
        close()
    }
}


