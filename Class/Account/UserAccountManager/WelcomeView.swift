//
//  WelcomeView.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/18.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeView: UIView {
    
    @IBOutlet weak var bottomLayoutContraintOfHeaderView: NSLayoutConstraint!
    @IBOutlet weak var avatar_default_big: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    
    
    class func welcomeView() -> WelcomeView? {
        let view = UINib(nibName: "WelcomeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? WelcomeView
        view?.frame = UIScreen.main.bounds
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nickName.text = MQLUserAccountManager.share.screen_name
        guard let urlStr = MQLUserAccountManager.share.avatar_large,
        let url = URL(string: urlStr) else {
            return
        }
        
        avatar_default_big.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"), completed: nil)
        avatar_default_big.layer.cornerRadius = avatar_default_big.bounds.height / 2
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            self.bottomLayoutContraintOfHeaderView.constant = self.bounds.height - 350
            self.layoutSubviews()
        }, completion: {(_) -> () in
            UIView.animate(withDuration: 1.0, animations: {
                self.nickName.alpha = 1.0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        })
        
    }
}
