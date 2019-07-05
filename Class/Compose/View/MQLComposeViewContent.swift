//
//  MQLComposeViewContent.swift
//  MicroBlog
//
//  Created by maqianli on 2019/7/5.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLComposeViewContent: UIView {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var textView: UITextView!
    
    class func composeViewContent() -> MQLComposeViewContent? {
        let nib = UINib(nibName: "MQLComposeViewContent", bundle: nil)
        let content = nib.instantiate(withOwner: nil, options:nil)[0] as? MQLComposeViewContent
        
        return content
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
