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
    weak var delegateHasText: MQLComposeTextViewDelegate?
    
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

        handleForTextViewDidChange()
    }
    
    func handleForTextViewDidChange() -> () {
        //处理展位标签
        placeholderLab.isHidden = hasText
        //处理代理
        delegateHasText?.hasText?(has: hasText)
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(notificationOfMQLComposeTextViewDidChange), object: nil, userInfo: ["hasText":hasText])
    }
    
    
}

//TextView和表情图片相关操作
extension MQLComposeTextView {
    //在末尾插入表情图片
    func insertEmotion(emotion: MQLEmotion?) -> () {
        
        guard let emotion = emotion else {
            //1、处理删除按钮
            self.deleteBackward()
            return
        }
        
        //2、处理emoji按钮
        if let emoji = emotion.emoji,
            let range = self.selectedTextRange {
            self.replace(range, withText: emoji)
            return
        }
        
        //2、处理自定义图片按钮
        let imageText = emotion.imageText(font: self.font!)
        
        let attStrM = NSMutableAttributedString(attributedString: self.attributedText)
        attStrM.replaceCharacters(in: self.selectedRange, with: imageText)
        
        let loc = self.selectedRange.location
        
        self.attributedText = attStrM
        
        self.selectedRange = NSRange(location: loc + 1, length: 0)
    }
    
    func pureString() -> String {
        
        var resultStr: String = ""
        guard let attStr = self.attributedText else {
            return resultStr
        }
        
        attStr.enumerateAttributes(in: NSRange(location: 0, length: attStr.length), options: []) { (dic, range, _) in
            if let attachment = dic[NSAttributedString.Key.attachment] as? MQLTextAttachment {
                resultStr += attachment.chs ?? ""
            }else{
                resultStr += attStr.attributedSubstring(from: range).string
            }
        }
        return resultStr
    }
}
