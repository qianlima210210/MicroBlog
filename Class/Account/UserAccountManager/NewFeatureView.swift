//
//  NewFeatureView.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/18.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class NewFeatureView: UIView {
    class func newFeatureView() -> NewFeatureView? {
        let view = UINib(nibName: "NewFeatureView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NewFeatureView
        view?.frame = UIScreen.main.bounds
        return view
    }
    

}
