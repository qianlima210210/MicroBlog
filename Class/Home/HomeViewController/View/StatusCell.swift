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
    
    var status: Status?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStatus(status: Status?) -> () {
        //设置前清空所有控件老内容
        resetContent()
        
        //保持status
        self.status = status
        
        //设置所有控件新内容
        setContent()
    }
    
    //设置前清空所有控件老内容
    private func resetContent() -> () {
        
//        touXiang.image = nil
//        name.text = nil
//        huiYuan.image = nil
//        shiJian.text = nil
//        laiYuan.text = nil
//        renZheng.image = nil
        zhengWen.text = nil
    }
    
    //设置所有控件新内容
    private func setContent() -> () {
//        touXiang.image = nil
//        name.text = nil
//        huiYuan.image = nil
//        shiJian.text = nil
//        laiYuan.text = nil
//        renZheng.image = nil
        zhengWen.text = status?.text
    }

}
