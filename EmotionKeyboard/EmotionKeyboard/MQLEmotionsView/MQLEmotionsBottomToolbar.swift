//
//  MQLEmotionsBottomToolbar.swift
//  EmotionKeyboard
//
//  Created by maqianli on 2019/7/9.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit

class MQLEmotionsBottomToolbar: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        addBtns()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width / CGFloat(subviews.count)
        let height = bounds.height
        
        //布局里面的所有按钮
        for (i, btn) in subviews.enumerated(){
            btn.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
        }
    }

}

extension MQLEmotionsBottomToolbar {
    func addBtns() -> () {
        let manager = MQLEmotionsManager.emotionsManager
        for package in manager.packages {
            let btn = UIButton()
            btn.setTitle(package.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            btn.setTitleColor(.white, for: .normal)
            btn.setTitleColor(.gray, for: .selected)
            btn.setTitleColor(.gray, for: .highlighted)
            
            //设置背景图
            var image = UIImage(named: "compose_emotion_table_\(package.bgImageName ?? "")_normal", in: manager.bundle, compatibleWith: nil)
            var imageSel = UIImage(named: "compose_emotion_table_\(package.bgImageName ?? "")_selected@2x", in: manager.bundle, compatibleWith: nil)
            
            let size = image?.size ?? CGSize()
            let edgeInsets = UIEdgeInsets(top: size.height * 0.5, left: size.width * 0.5, bottom: size.height * 0.5, right: size.width * 0.5)
            image = image?.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
            imageSel = imageSel?.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
            
            btn.setBackgroundImage(image, for: .normal)
            btn.setBackgroundImage(imageSel, for: .selected)
            btn.setBackgroundImage(imageSel, for: .highlighted)
            
            btn.sizeToFit()
            addSubview(btn)
        }
    }
}
