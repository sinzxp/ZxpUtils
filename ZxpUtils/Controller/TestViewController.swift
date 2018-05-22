//
//  TestTransitionFromViewController.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/4/24.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class firstViewController: ZXPFixedSelectChildTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        print("firstViewController - viewWillAppear")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("firstViewController - viewDidAppear")
    }
    
    deinit {
        print("销毁firstViewController")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        cell.textLabel?.text = "firstViewController - \(indexPath.section) --- \(rootSegment.sss)"
        cell.textLabel?.text = "firstViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rootSegment.sss = "\(indexPath.section)"
//        self.tableView.reloadData()
        print("\(atTheTopViewController())")
    }

}

class secondViewController: ZXPFixedSelectChildTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        print("secondViewController - viewWillAppear")

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("secondViewController - viewDidAppear")
    }
    
    deinit {
        print("销毁secondViewController")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        cell.textLabel?.text = "secondViewController - \(indexPath.section) --- \(rootSegment.sss)"
        cell.textLabel?.text = "secondViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rootSegment.sss = "\(indexPath.section)"
//        self.tableView.reloadData()
        self.showText("哈哈哈哈")
    }

}

class thirdViewController: ZXPFixedSelectChildTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor
        self.tableView.addRefreshHeader(target: self, action: #selector(requestMore))
//        self.tableView.mj_header.ignoredScrollViewContentInsetTop = -194
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        print("thirdViewController - viewWillAppear")

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("thirdViewController - viewDidAppear")

    }

    deinit {
        print("销毁thirdViewController")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "thirdViewController - \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

//自定义的Collection View单元格
class GalleryCollectionViewCell: UICollectionViewCell {
    
    //用于显示图片
    var labelView: UILabel!
    
    public func setup() {
        //  展示图片
        labelView = UILabel(frame: contentView.bounds)
        labelView.textAlignmentCenter()
        labelView.backgroundColor = UIColor.randomColor
        contentView.addSubview(labelView)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

}

class GalleryViewController: UIViewController {
    
    //普通的flow流式布局
    var flowLayout:UICollectionViewFlowLayout!
    //自定义的线性布局
    var linearLayput:LinearCollectionViewLayout!
    
    var stackLayput:StackCollectionViewLayout!

    
    var collectionView:UICollectionView!
    //重用的单元格的Identifier
    let CellIdentifier = "myCell"
    
    var abc = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 60, height: 60)
        flowLayout.sectionInset = UIEdgeInsets(top: 74, left: 0, bottom: 0, right: 0)
        
        linearLayput = LinearCollectionViewLayout()
//        linearLayput.itemWidth = 200
//        linearLayput.itemHeight = 150
        
        stackLayput = StackCollectionViewLayout()
        stackLayput.itemSize = CGSize(width:120, height:120)

        //初始化Collection View
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 70, width: ZSCREEN_WIDTH, height: 200) , collectionViewLayout: stackLayput)
        
        //Collection View代理设置
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        //注册重用的单元格
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        
        //将Collection View添加到主视图中
        view.addSubview(collectionView)
        
        collectionView.addTapViewGesture(self, action: #selector(handleTap))

    }
    
    //点击手势响应
    func handleTap(_ sender:UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.ended {
            let tapPoint = sender.location(in: self.collectionView)
            //点击的是单元格元素 didSelectItemAt方法也可以
            if let indexPath = self.collectionView.indexPathForItem(at: tapPoint) {
                //通过performBatchUpdates对collectionView中的元素进行批量的插入，删除，移动等操作
                //同时该方法触发collectionView所对应的layout的对应的动画。
                print("删除 -- \(indexPath) --- \(tapPoint)")
                self.collectionView.performBatchUpdates({ () -> Void in
                    self.collectionView.deleteItems(at: [indexPath])
                    abc -= 1
                }, completion: nil)
            
            }
            //点击的是空白位置
            else{
                print("插入")
                //新元素插入的位置（开头）
                let index = 0
                abc += 1
                self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            }
            
//            self.collectionView.collectionViewLayout.invalidateLayout()
//            //交替切换新布局
//            let newLayout = collectionView.collectionViewLayout.isKind(of:LinearCollectionViewLayout.self) ? flowLayout : linearLayput
//            collectionView.setCollectionViewLayout(newLayout!, animated: true)
        }
    }
}

//Collection View数据源协议相关方法
extension GalleryViewController: UICollectionViewDataSource {
    //获取分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //获取每个分区里单元格数量
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return abc
    }
    
    //返回每个单元格视图
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取重用的单元格
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CellIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.labelView.text = "\(indexPath)"
        return cell
    }
}

//Collection View样式布局协议相关方法
extension GalleryViewController: UICollectionViewDelegate {
    
}
