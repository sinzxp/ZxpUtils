//
//  ClickOnTheViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/14.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ClickOnTheViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let eview = EffectView(frame: CGRect(x: 100, y: 100, width: 50, height: 50) )
        eview.backgroundColor = UIColor.alizarin()
        eview.isNarrow = true
        self.view.addSubview(eview)
        
        let view = UIView(frame: CGRect(x: 20, y: 20, width: 20, height: 20) )
        view.backgroundColor = UIColor.blue
        eview.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
