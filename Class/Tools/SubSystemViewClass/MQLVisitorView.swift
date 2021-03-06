//
//  MQLVisitorView.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/4.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLVisitorView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var hintLab: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    var visitorInfo: [String : String]?{
        didSet {
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else { return }
            
            hintLab.text = message
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconImageView.image = UIImage(named: imageName)
            houseImageView.isHidden = true
        }
    }
    
    // 旋转iconImageView
    func startAnimation() -> () {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * Double.pi
        animation.duration = 15
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        //将动画添加到ImageView
        iconImageView.layer.add(animation, forKey: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
    }
    
}
