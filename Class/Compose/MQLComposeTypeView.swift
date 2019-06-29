//
//  MQLComposeTypeView.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/28.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLComposeTypeView: UIView {

    @IBOutlet weak var scrollViewContainer: UIView!
    var scrollView = UIScrollView()
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var centerXOfBackBtn: NSLayoutConstraint!
    @IBOutlet weak var centerXOfCloseBtn: NSLayoutConstraint!
    
    /// 按钮数据数组
    private let buttonsInfo = [
        ["imageName":"tabbar_compose_idea", "title":"文字"],
        ["imageName":"tabbar_compose_photo", "title":"图片/视频"],
        ["imageName":"tabbar_compose_weibo", "title":"长微博"],
        ["imageName":"tabbar_compose_lbs", "title":"签到"],
        ["imageName":"tabbar_compose_review", "title":"点评"],
        ["imageName":"tabbar_compose_more", "title":"更多"],
        ["imageName":"tabbar_compose_friend", "title":"好友圈"],
        ["imageName":"tabbar_compose_wbcamera", "title":"微博相机"],
        ["imageName":"tabbar_compose_music", "title":"音乐"],
        ["imageName":"tabbar_compose_shooting", "title":"拍摄"]
    ]
    
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
        addScrollView()
        addBtns()
    }
    
    @IBAction func close() {
        self.removeFromSuperview()
    }
    
    @IBAction func back() {
        //先滚动到第1页
        let rect = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.scrollRectToVisible(rect, animated: true)
        
        //调整返回按钮及关闭按钮的水平间距
        centerXOfBackBtn.constant = 0
        centerXOfCloseBtn.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            //hide backBtn
            self.backBtn.isHidden = true
        }
    }
    
}

extension MQLComposeTypeView {
    
    func addScrollView() -> () {
        scrollViewContainer.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }
        
        scrollView.contentSize = CGSize(width: self.bounds.width * CGFloat(2), height: scrollViewContainer.bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
    }
    
    func addBtns() -> () {
        //强行获取frame
        layoutIfNeeded()
        
        //添加第一个视图
        let viewOne = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
        viewOne.backgroundColor = .orange
        scrollView.addSubview(viewOne)
        addBtnsToView(view: viewOne, idx: 0)
        
        //添加第2个视图
        let viewTwo = UIView(frame: CGRect(x: scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
        viewTwo.backgroundColor = .yellow
        scrollView.addSubview(viewTwo)
        addBtnsToView(view: viewTwo, idx: 6)
    }
    
    func addBtnsToView(view: UIView, idx: Int) -> () {
        for i in idx..<(6+idx) {
            
            if i >= buttonsInfo.count {
                break
            }
            
            let info = buttonsInfo[i]
            let image = UIImage(named: info["imageName"] ?? "")
            let title = info["title"]
            let composeTypeButton = MQLMQLComposeTypeButton.composeTypeButton(image: image, title: title) ?? MQLMQLComposeTypeButton()
            composeTypeButton.tag = i + 1
            composeTypeButton.addTarget(self, action: #selector(composeTypeBtnClicked(sender:)), for: .touchUpInside)
            view.addSubview(composeTypeButton)
            
            let row: CGFloat = CGFloat((i >= 6 ? i - 6 : i) / 3)
            let col: CGFloat = CGFloat((i >= 6 ? i - 6 : i) % 3)
            let buttonWidth: CGFloat = 100
            let hMargin = (view.bounds.width - buttonWidth * 3) / 4
            let vMargin: CGFloat = 24
            composeTypeButton.frame = CGRect(x: (col + 1) * hMargin + col * buttonWidth,
                   y: row * (vMargin + buttonWidth),
                   width: buttonWidth,
                   height: buttonWidth)
            view.addSubview(composeTypeButton)
            
        }
    }
    
    @objc func composeTypeBtnClicked(sender: MQLMQLComposeTypeButton) -> () {
        print("tag = \(sender.tag)")
        if sender.tag == 6 {
            handleMore()
        }
    }
    
    func handleMore() -> () {
        //先滚动到第二页
        let rect = CGRect(x: scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.scrollRectToVisible(rect, animated: true)
        
        //show backBtn
        backBtn.isHidden = false
        
        //调整返回按钮及关闭按钮的水平间距
        let margin = scrollView.bounds.width / 6
        centerXOfBackBtn.constant = -margin
        centerXOfCloseBtn.constant = margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

}
