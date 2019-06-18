//
//  TitleButton.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/18.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    init(title: String?) {
        super.init(frame: CGRect.zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        setTitleColor(.black, for: .highlighted)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,
              let imageView = imageView else {
                return
        }
        
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.bounds.width
    }
}
