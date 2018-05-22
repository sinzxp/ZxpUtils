//
//  LinearCollectionViewLayout.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/22.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class LinearCollectionViewLayout: UICollectionViewFlowLayout {
    
    //元素宽度
    var itemWidth:CGFloat = 100
    //元素高度
    var itemHeight:CGFloat = 100
    
    //对一些布局的准备操作放在这里
    override func prepare() {
        super.prepare()
        //设置元素大小
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        //设置滚动方向
        self.scrollDirection = .horizontal
        //设置间距
        self.minimumLineSpacing = self.collectionView!.bounds.width / 2 -  itemWidth
        
        //设置内边距
        //左右边距为了让第一张图片与最后一张图片出现在最中央
        //上下边距为了让图片横行排列，且只有一行
        let left = (self.collectionView!.bounds.width - itemWidth) / 2
        let top = (self.collectionView!.bounds.height - itemHeight) / 2
        self.sectionInset = UIEdgeInsetsMake(top, left, top, left)
    }

}
