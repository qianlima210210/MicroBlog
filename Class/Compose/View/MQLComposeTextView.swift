//
//  MQLComposeTextView.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/7/6.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

@objc protocol MQLComposeTextViewDelegate : NSObjectProtocol {
    @objc optional func hasText(has: Bool) -> ()
}

class MQLComposeTextView: UITextView {

    var placeholderLab: UILabel = UILabel()
    var delegateHasText: MQLComposeTextViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addPlaceholderLab()
        delegate = self
    }
    
    func addPlaceholderLab() -> () {
        placeholderLab.text = "请输入信息..."
        placeholderLab.font = self.font
        placeholderLab.sizeToFit()
        placeholderLab.frame.origin = CGPoint(x:5, y:8)
        
        self.addSubview(placeholderLab)
    }
}

extension MQLComposeTextView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView){
        placeholderLab.isHidden = textView.hasText
        
        delegateHasText?.hasText?(has: textView.hasText)
    }
}
