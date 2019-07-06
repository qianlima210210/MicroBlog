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
    @IBOutlet weak var bottomConstraintOfToolBar: NSLayoutConstraint!
    
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
        setupToolbar()
        registerNotification()
        
    }
    
    /// 设置工具栏
    func setupToolbar() {
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        // 遍历数组
        var items = [UIBarButtonItem]()
        for s in itemSettings {
            
            guard let imageName = s["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            
            // 判断 actionName
            if let actionName = s["actionName"] {
                // 给按钮添加监听方法
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            // 追加按钮
            items.append(UIBarButtonItem(customView: btn))
            
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        // 删除末尾弹簧
        items.removeLast()
        
        toolbar.items = items
    }
    
    @objc func emoticonKeyboard() -> () {
        
    }
    
}

extension MQLComposeViewContent {
    
    @objc func receiveNotificationOfUIKeyboardWillChangeFrame(n: Notification) -> () {
        //获取键盘坐标（基于UIScreen）
        guard let frame = n.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
        let duration = n.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double else {
            return
        }
        //调整工具条底部约束（X系列之后的需要减去34，因为bottomConstraintOfToolBar已处于UIScreen底部34位置）
        bottomConstraintOfToolBar.constant = UIScreen.main.bounds.height - frame.minY
        if UIApplication.shared.statusBarFrame.height == 44 {
            if frame.minY != UIScreen.main.bounds.height {
                bottomConstraintOfToolBar.constant = UIScreen.main.bounds.height - frame.minY - 34//键盘弹出
            }else{
                bottomConstraintOfToolBar.constant = 0//键盘收起
            }
        }
        
        //动画
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
        
    }
    
    func registerNotification() -> () {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveNotificationOfUIKeyboardWillChangeFrame(n:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                                object:nil)
    }
    
}
