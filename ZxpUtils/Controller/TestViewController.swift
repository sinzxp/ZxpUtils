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
    var imageView: UIImageView!
    
    public func setup() {
        //  展示图片
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.randomColor
        contentView.addSubview(imageView)
        
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
    
    var collectionView:UICollectionView!
    //重用的单元格的Identifier
    let CellIdentifier = "myCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 60)
        flowLayout.sectionInset = UIEdgeInsets(top: 74, left: 50, bottom: 50, right: 50)
//        flowLayout.scrollDirection = .horizontal
        
        //初始化Collection View
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 70, width: ZSCREEN_WIDTH, height: 500) , collectionViewLayout: flowLayout)
        
        //Collection View代理设置
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        //注册重用的单元格
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        
        //将Collection View添加到主视图中
        view.addSubview(collectionView)

    }
}

//Collection View数据源协议相关方法
extension GalleryViewController: UICollectionViewDataSource {
    //获取分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //获取每个分区里单元格数量
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    //返回每个单元格视图
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取重用的单元格
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CellIdentifier, for: indexPath) as! GalleryCollectionViewCell
        return cell
    }
}

//Collection View样式布局协议相关方法
extension GalleryViewController: UICollectionViewDelegate {
    
}
