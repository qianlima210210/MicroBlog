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
    
    @IBOutlet weak var widthConstraintOfName: NSLayoutConstraint!
    
    var statusViewModel: MQLStatusViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
//        huiYuan.image = nil
//        shiJian.text = nil
//        laiYuan.text = nil
//        renZheng.image = nil
        zhengWen.text = nil
    }
    
    //设置所有控件新内容
    private func setContent() -> () {
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
        
        name.text = statusViewModel?.dataModel.user?.screen_name
        widthConstraintOfName.constant = (((name.text ?? "") as NSString).size(font: name.font, width: 1000, height: name.bounds.height)).width
        
//        huiYuan.image = nil
//        shiJian.text = nil
//        laiYuan.text = nil
//        renZheng.image = nil
        zhengWen.text = statusViewModel?.dataModel.text
    }
    


}
