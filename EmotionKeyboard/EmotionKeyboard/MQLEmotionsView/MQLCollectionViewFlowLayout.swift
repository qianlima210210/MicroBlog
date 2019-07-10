//
//  MQLCollectionViewFlowLayout.swift
//  EmotionKeyboard
//
//  Created by maqianli on 2019/7/10.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit

class MQLCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        //设定滚动方向，默认是垂直滚动的
        //垂直滚动，cell从左到右依次布局
        //水平滚动，cell从上到下依次布局
        scrollDirection = .horizontal
        
        
        
    }
}
