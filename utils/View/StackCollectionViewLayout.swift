//
//  StackCollectionViewLayout.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/22.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class StackCollectionViewLayout: UICollectionViewFlowLayout {
    
    
    //角度（从上到下，每个元素依次使用）
    let angles: [CGFloat]  = [0, 0.2, -0.5, -0.2, 0.5]
    
    //边界发生变化时是否重新布局（视图滚动的时候也会触发）
    //会重新调用prepareLayout和调用
    //layoutAttributesForElementsInRect方法获得部分cell的布局属性
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //rect范围下所有单元格位置属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            var attrArray: [UICollectionViewLayoutAttributes] = []
            let itemCount = self.collectionView!.numberOfItems(inSection: 0)
            for i in 0..<itemCount {
                let attr = self.layoutAttributesForItem(at: IndexPath(item: i, section: 0))!
                attrArray.append(attr)
            }
            return attrArray
    }
    
    //这个方法返回每个单元格的位置、大小、角度
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.center = CGPoint(x:self.collectionView!.bounds.width / 2,
                                  y:self.collectionView!.bounds.height / 2)
            attr.size = itemSize
            attr.transform = CGAffineTransform(rotationAngle: angles[indexPath.item % angles.count])
            //让第一张显示在最上面
            attr.zIndex = self.collectionView!.numberOfItems(inSection: 0) - indexPath.item
            return attr
    }

}
