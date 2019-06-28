//
//  MQLComposeTypeView.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/28.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLComposeTypeView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    class func composeTypeView() ->MQLComposeTypeView? {
        let nib = UINib(nibName: "MQLComposeTypeView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as? MQLComposeTypeView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        addBtns()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = UIScreen.main.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBtns()
    }
    
}

extension MQLComposeTypeView {
    func addBtns() -> () {
        let image = UIImage(named: "tabbar_compose_idea")
        let title = "点子"
        let btn = MQLMQLComposeTypeButton.composeTypeButton(image: image, title: title)
        btn?.center = contentView.center
        btn?.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
        contentView.addSubview(btn!)
    }
    
    @objc func btnClicked(sender: MQLMQLComposeTypeButton) -> () {
        print(#function)
    }
}
