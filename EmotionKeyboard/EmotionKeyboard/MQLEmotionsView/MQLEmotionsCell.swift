//
//  MQLEmotionsCell.swift
//  EmotionKeyboard
//
//  Created by ma qianli on 2019/7/9.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit

//每一个cell和collectionView大小一样
//每一个cell中用九宫格的算法，自行添加20个表情
//最后一个位置放置删除按钮
class MQLEmotionsCell: UICollectionViewCell {

    var cellHeight: CGFloat = 0.0 {
        didSet{
            addBtns()
        }
    }
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func addBtns() -> () {
        
        if containerView.subviews.count > 0 {
            return
        }
        
        let rowCount: Int = 3    //行总数
        let colCount: Int = 7    //列总数
        
        let marginLR: CGFloat = 8     //左右边距
        let marginB: CGFloat = 16     //bottom边距
        let btnWidth = (UIScreen.main.bounds.width - marginLR * 2) / CGFloat(colCount)     //按钮宽度
        let btnHeight =  (cellHeight - marginB) / CGFloat(rowCount)                      //按钮高度
        
        
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            btn.frame = CGRect(x: CGFloat(col) * btnWidth, y: CGFloat(row) * btnHeight, width: btnWidth, height: btnHeight)
            btn.backgroundColor = .black
            containerView.addSubview(btn)
        }
    }

}
