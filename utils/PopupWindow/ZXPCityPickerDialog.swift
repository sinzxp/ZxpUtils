//
//  ZXPCityPickerDialog.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/21.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import SwiftyJSON

///选择城市弹窗版 中下位置
class ZXPCityPickerDialog: UIView {
    
    var addressJson:[JSON] = []
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    var records:[JSON] = []
    
    typealias pickerCallback = (_ data: [JSON]) -> Void
    
    /* Consts */
    fileprivate let kpickerDialogDefaultButtonHeight: CGFloat = 50
    fileprivate let kpickerDialogDefaultButtonSpacerHeight: CGFloat = 1
    fileprivate let kpickerDialogCornerRadius: CGFloat = 7
    fileprivate let kpickerDialogDoneButtonTag: Int = 1
    /* Views */
    fileprivate var dialogView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var cancelButton: UIButton!
    fileprivate var doneButton: UIButton!
    //选择器
    var pickerView:UIPickerView!
    
    fileprivate var callback: pickerCallback?
    
    //显示位置
    var positionBottom = false
    
    /* Overrides */
    init(_ posBottom:Bool = false) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.positionBottom = posBottom
        initData()
        add()
        setupView()
    }
    
    func initData() {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "area", ofType: "txt")!
        let txt = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        addressJson = JSON(parseJSON:txt!).arrayValue
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
    
    func show(_ title: String, doneButtonTitle: String = "Done", cancelButtonTitle: String = "Cancel", callback: @escaping pickerCallback) {
        self.titleLabel.text = title
        self.doneButton.setTitle(doneButtonTitle, for: UIControlState())
        self.cancelButton.setTitle(cancelButtonTitle, for: UIControlState())
        self.callback = callback
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
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
            self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: self.bounds.size.width, height: 180))
        } else {
            view.layer.cornerRadius = kpickerDialogCornerRadius
            view.frame.origin = CGPoint(x: self.bounds.size.width / 2 - 150, y: self.bounds.size.height / 2 - 115)
            view.frame.size = CGSize(width: 300, height: 230)
            
            self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 30, width: 300, height: 150))
        }
        
        //将dataSource设置成自己
        pickerView.dataSource=self
        //将delegate设置成自己
        pickerView.delegate=self
        
        view.addSubview(self.pickerView)
        
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
            lineView.frame = CGRect(x: 0, y: kpickerDialogDefaultButtonHeight , width: container.bounds.size.width, height: kpickerDialogDefaultButtonSpacerHeight)
        } else {
            lineView.frame = CGRect(x: 0, y: container.bounds.size.height - kpickerDialogDefaultButtonHeight - kpickerDialogDefaultButtonSpacerHeight, width: container.bounds.size.width, height: kpickerDialogDefaultButtonSpacerHeight)
        }
        lineView.backgroundColor = UIColor(red: 198 / 255, green: 198 / 255, blue: 198 / 255, alpha: 1)
        container.addSubview(lineView)
        
        self.cancelButton = UIButton(type: UIButtonType.custom)
        self.cancelButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.cancelButton.setTitleColor(UIColor.appleBlue, for: UIControlState())
        self.cancelButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.cancelButton.addTarget(self, action: #selector(close), for: UIControlEvents.touchUpInside)
        container.addSubview(self.cancelButton)
        
        self.doneButton = UIButton(type: UIButtonType.custom) as UIButton
        self.doneButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.doneButton.setTitleColor(UIColor.appleBlue, for: UIControlState())
        self.doneButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.doneButton.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        container.addSubview(self.doneButton)
        
        if positionBottom {
            let buttonWidth = container.bounds.size.width / 7
            self.cancelButton.frame = CGRect( x: 0, y: 0, width: buttonWidth, height: kpickerDialogDefaultButtonHeight)
            self.doneButton.frame = CGRect( x: container.bounds.size.width - buttonWidth, y: 0, width: buttonWidth,height: kpickerDialogDefaultButtonHeight)
        } else {
            let buttonWidth = container.bounds.size.width / 2
            self.cancelButton.frame = CGRect( x: 0, y: container.bounds.size.height - kpickerDialogDefaultButtonHeight, width: buttonWidth, height: kpickerDialogDefaultButtonHeight)
            self.doneButton.frame = CGRect( x: buttonWidth, y: container.bounds.size.height - kpickerDialogDefaultButtonHeight, width: buttonWidth,height: kpickerDialogDefaultButtonHeight)
        }
        
    }
    
    func buttonTapped(_ sender: UIButton!) {
        self.callback?(records)
        close()
    }

}

extension ZXPCityPickerDialog: UIPickerViewDelegate, UIPickerViewDataSource{

    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //设置选择框的行数，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.addressJson.count
        } else if component == 1 {
            let province = self.addressJson[provinceIndex]
            return province["level2"].count
        } else {
            let province = self.addressJson[provinceIndex]
            let city = province["level2"][cityIndex]
            return city["level3"].count
        }
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 20)
            pickerLabel?.textAlignment = .center
            pickerLabel?.adjustsFontSizeToFitWidth = true
        }
        if component == 0 {
            pickerLabel?.text = self.addressJson[row]["name"].stringValue
        } else if component == 1 {
            let province = self.addressJson[provinceIndex]
            pickerLabel?.text = province["level2"][row]["name"].stringValue
        } else {
            let province = self.addressJson[provinceIndex]
            let city = province["level2"][cityIndex]
            pickerLabel?.text = city["level3"][row]["name"].stringValue
        }
        pickerLabel?.textColor = UIColor.black
        return pickerLabel!
    }
    
    //设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        switch (component) {
        case 0:
            provinceIndex = row
            cityIndex = 0
            areaIndex = 0
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 1:
            cityIndex = row
            areaIndex = 0
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 2:
            areaIndex = row
        default:
            break
        }
        add()
    }
    
    func add() {
        let province = self.addressJson[provinceIndex]
        let city = province["level2"][cityIndex]
        let area = city["level3"][areaIndex]
        self.records.removeAll()
        self.records.append(province)
        self.records.append(city)
        self.records.append(area)
    }
    
}
