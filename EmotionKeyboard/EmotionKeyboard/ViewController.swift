//
//  ViewController.swift
//  EmotionKeyboard
//
//  Created by maqianli on 2019/7/2.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.inputView = MQLEmotionsView.emotionsView(keyboardHeight: 346, emotionSelected: {[weak self] (emotion) in
            self?.insertEmotion(emotion: emotion)
        })
    }

    func insertEmotion(emotion: MQLEmotion?) -> () {
        
        guard let emotion = emotion else {
            //1、处理删除按钮
            textView.deleteBackward()
            return
        }
        
        //2、处理emoji按钮
        if let emoji = emotion.emoji,
            let range = textView.selectedTextRange {
            textView.replace(range, withText: emoji)
            return
        }
        
        //2、处理自定义图片按钮
        let imageText = emotion.imageText(font: textView.font!)
        
        let attStrM = NSMutableAttributedString(attributedString: textView.attributedText)
        attStrM.replaceCharacters(in: textView.selectedRange, with: imageText)
        
        let loc = textView.selectedRange.location
        
        textView.attributedText = attStrM
        
        textView.selectedRange = NSRange(location: loc + 1, length: 0)
    }

}




















