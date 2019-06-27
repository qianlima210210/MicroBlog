//
//  StatusCell.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/20.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {

    @IBOutlet weak var touXiang: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var huiYuan: UIImageView!
    @IBOutlet weak var shiJian: UILabel!
    @IBOutlet weak var laiYuan: UILabel!
    @IBOutlet weak var renZheng: UIImageView!
    @IBOutlet weak var zhengWen: UILabel!
    @IBOutlet weak var beiZhuanFaZhengWen: UILabel?
    @IBOutlet weak var picturesViewContainer: UIView!
    @IBOutlet weak var bottomToolsBarContainer: UIView!
    
    @IBOutlet weak var widthConstraintOfName: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraintOfZhengWen: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfBeiZhuanFaZhengWen: NSLayoutConstraint?
    
    @IBOutlet weak var heightConstraintOfPicturesViewContainer: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfBeiZhuanFaWeiBoBeiJingAnNiu: NSLayoutConstraint?
    
    
    var picturesImageViews = [UIImageView]()
    
    var retweetBtn = UIButton(type: .custom)
    var commentBtn = UIButton(type: .custom)
    var likeBtn = UIButton(type: .custom)
    
    var statusViewModel: MQLStatusViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        addFenXiangPingLunDianZanToBottomToolsBarContainer()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStatus(statusViewModel: MQLStatusViewModel?) -> () {
        //设置前清空所有控件老内容
        resetContent()
        
        //保持status
        self.statusViewModel = statusViewModel
        
        //设置所有控件新内容
        setContent()
    }
    
    //设置前清空所有控件老内容
    private func resetContent() -> () {
        
        touXiang.image = nil
        name.text = nil
        huiYuan.image = nil
//        shiJian.text = nil
//        laiYuan.text = nil
        renZheng.image = nil
        zhengWen.text = nil
        beiZhuanFaZhengWen?.text = nil
        
        //清空picturesViewContainern内容
        //1.1 多图处理
        if picturesImageViews.count == 0 {
            
            picturesViewContainer.clipsToBounds = true
            let widthOfImageView = widthOfPicturesViewContainer / 3
            let count = 3
            for i in 0..<count * count{
                let row = i / 3
                let col = i % 3
                
                let frame = CGRect(x: CGFloat(col) * (widthOfImageView + innerMargin),
                                   y: outerMargin + CGFloat(row) * (widthOfImageView + innerMargin),
                                   width: widthOfImageView,
                                   height: widthOfImageView)
                let imageView = UIImageView(frame: frame)
                imageView.contentMode = .scaleToFill
                imageView.backgroundColor = .red
                picturesViewContainer.addSubview(imageView)
                picturesImageViews.append(imageView)
            }
            
        }else{
            for item in picturesImageViews {
                item.isHidden = false
                item.image = nil
            }
        }
        
        //恢复imageView0大小
        picturesImageViews[0].frame = CGRect(x: CGFloat(0),
                                             y: outerMargin,
                                             width: widthOfPicturesViewContainer / 3,
                                             height: widthOfPicturesViewContainer / 3)
        

        
    }
    
    //设置所有控件新内容
    private func setContent() -> () {
        //设置头像
        let layer = self.touXiang.layer
        layer.cornerRadius = self.touXiang.bounds.width / 2
        if statusViewModel?.touXiangImage == nil {
            let url = statusViewModel?.dataModel.user?.profile_image_url ?? ""
            let placeholderImage = UIImage(named: "avatar_default_big")
            touXiang.sd_setImage(with: URL(string: url), placeholderImage: placeholderImage, options: []) {[weak self] (image, _, _, _) in
                self?.statusViewModel?.touXiangImage = image
                self?.touXiang.image = image
            }
        }else{
            self.touXiang.image = self.statusViewModel?.touXiangImage
        }
        
        //设置名称
        name.text = statusViewModel?.dataModel.user?.screen_name
        widthConstraintOfName.constant = (((name.text ?? "") as NSString).size(font: name.font, width: 1000, height: name.bounds.height)).width
        
        //设置会员
        self.huiYuan.image = statusViewModel?.huiYuanImage

        
//        shiJian.text = nil
//        laiYuan.text = nil
        
        //设置认证
        renZheng.image = statusViewModel?.renZhengImage
        
        //设置正文
        zhengWen.text = statusViewModel?.dataModel.text
        heightConstraintOfZhengWen.constant = statusViewModel?.heightOfZhengWen ?? 0
        
        //设置被转发正文
        beiZhuanFaZhengWen?.text = statusViewModel?.beiZhuanFaZhengWenText
        heightConstraintOfBeiZhuanFaZhengWen?.constant = statusViewModel?.heightOfBeiZhuanFaZhengWen ?? 0

        //设置图像视图容器
        heightConstraintOfPicturesViewContainer.constant = statusViewModel?.sizeOfPicturesViewContainer.height ?? 0
        //1.1 配图一般处理
        let count =  statusViewModel?.pic_urls?.count ?? 0
        for i in count..<9 {
            picturesImageViews[i].isHidden = true
        }
        if count > 0 {
            for i in 0..<count{
                var thumbnail_pic = statusViewModel?.pic_urls?[i]["thumbnail_pic"] as? NSString ?? ""
                thumbnail_pic = thumbnail_pic.replacingOccurrences(of: "thumbnail", with: "bmiddle") as NSString
                let url = URL(string: thumbnail_pic as String)
                picturesImageViews[i].sd_setImage(with: url, placeholderImage: nil, options: [], context: nil)
            }
        }
        
        //1.1 配图特殊处理
        if count == 1 {
            
            let width = statusViewModel?.sizeOfPicturesViewContainer.width ?? 0 //只有一张图是，宽度才有用武之地
            let height = statusViewModel?.sizeOfPicturesViewContainer.height ?? 0
            if height > CGFloat(0){
                //变更imageView0大小
                picturesImageViews[0].frame = CGRect(x: CGFloat(0),
                                                     y: outerMargin,
                                                     width: width,
                                                     height: height - outerMargin)
            }
        }
        //heightConstraintOfBeiZhuanFaWeiBoBeiJingAnNiu=outerMargin+heightOfBeiZhuanFaZhengWen+picturesViewContainer.height
        heightConstraintOfBeiZhuanFaWeiBoBeiJingAnNiu?.constant = outerMargin + (heightConstraintOfBeiZhuanFaZhengWen?.constant ?? 0) + heightConstraintOfPicturesViewContainer.constant

        //设置底部工具栏
        let reposts_count = statusViewModel?.dataModel.reposts_count ?? 0
        retweetBtn.setTitle(reposts_count > 0 ? "\(reposts_count)" : "转发", for: .normal)
        
        let comments_count = statusViewModel?.dataModel.comments_count ?? 0
        commentBtn.setTitle(comments_count > 0 ? "\(comments_count)" : "评论", for: .normal)
        
        let attitudes_count = statusViewModel?.dataModel.attitudes_count ?? 0
        likeBtn.setTitle(attitudes_count > 0 ? "\(attitudes_count)" : "点赞", for: .normal)
    }
    


}

//底部工具栏
extension StatusCell {
    func addFenXiangPingLunDianZanToBottomToolsBarContainer() -> () {
        let widthOfFenGeXian: CGFloat = 1
        let widthOfBtn = (UIScreen.main.bounds.width - CGFloat(10 * 2) - 2 * widthOfFenGeXian) / 3
        
        //timeline_icon_retweet
        retweetBtn.setImage(UIImage(named: "timeline_icon_retweet"), for: .normal)
        retweetBtn.addTarget(self, action: #selector(retweetBtnClicked), for: .touchUpInside)
        retweetBtn.setTitleColor(.gray, for: .normal)
        retweetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        retweetBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        bottomToolsBarContainer.addSubview(retweetBtn)
        retweetBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(widthOfBtn)
        }
        
        //timeline_icon_comment
        commentBtn.setImage(UIImage(named: "timeline_icon_comment"), for: .normal)
        commentBtn.addTarget(self, action: #selector(commentBtnClicked), for: .touchUpInside)
        commentBtn.setTitleColor(.gray, for: .normal)
        commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        bottomToolsBarContainer.addSubview(commentBtn)
        commentBtn.snp_makeConstraints { (make) in
            make.left.equalTo(retweetBtn.snp_right).offset(1)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(widthOfBtn)
        }
        
        //timeline_icon_unlike/timeline_icon_like
        likeBtn.setImage(UIImage(named: "timeline_icon_unlike"), for: .normal)
        likeBtn.addTarget(self, action: #selector(likeBtnClicked), for: .touchUpInside)
        likeBtn.setTitleColor(.gray, for: .normal)
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        likeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        bottomToolsBarContainer.addSubview(likeBtn)
        likeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(commentBtn.snp_right).offset(1)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(widthOfBtn)
        }
    }
    
    @objc func retweetBtnClicked() -> () {
        print(#function)
    }
    
    @objc func commentBtnClicked() -> () {
         print(#function)
    }
    
    @objc func likeBtnClicked() -> () {
         print(#function)
    }
    
}
