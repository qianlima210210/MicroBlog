//
//  MQLComposeTypeView.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/28.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLComposeTypeView: UIView {
    
    class func composeTypeView() ->MQLComposeTypeView? {
        let nib = UINib(nibName: "MQLComposeTypeView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as? MQLComposeTypeView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = UIScreen.main.bounds
    }
    
}
