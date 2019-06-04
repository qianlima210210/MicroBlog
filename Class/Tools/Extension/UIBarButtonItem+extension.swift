//
//  UIBarButtonItem+extension.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/31.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
        
        let customView: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBack {
            let image = UIImage(named: "navigationbar_back_withtext")
            let highlightedImage = UIImage(named: "navigationbar_back_withtext_highlighted")
            customView.setImage(image, for: .normal)
            customView.setImage(highlightedImage, for: .highlighted)
        }
        
        customView.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView:customView)
    }
}
