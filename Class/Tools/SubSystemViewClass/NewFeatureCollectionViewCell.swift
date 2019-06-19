//
//  NewFeatureCollectionViewCell.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/19.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class NewFeatureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var pageNumber: Int = -1 {
        didSet{
            //由于复用，所以先清空先前内容
            imageView.image = nil
            
            //谁知当前内容
            switch pageNumber {
            case 0:
                imageView.image = UIImage(named: "new_feature_1")
            case 1:
                imageView.image = UIImage(named: "new_feature_2")
            case 2:
                imageView.image = UIImage(named: "new_feature_3")
            case 3:
                imageView.image = UIImage(named: "new_feature_4")
            default:
                imageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
