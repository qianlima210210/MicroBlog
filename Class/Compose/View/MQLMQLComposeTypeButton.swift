//
//  MQLMQLComposeTypeButton.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/28.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLMQLComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    class func composeTypeButton(image: UIImage?, title: String?) -> MQLMQLComposeTypeButton? {
        let nib = UINib(nibName: "MQLMQLComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as? MQLMQLComposeTypeButton
        
        btn?.imageView.image = image
        btn?.title.text = title
        
        return btn
    }
}
