//
//  MQLStatusViewModel.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/21.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLStatusViewModel: NSObject {
    
    var dataModel: Status
    
    var touXiangImage: UIImage?
    
    init(_ dataModel: Status) {
        self.dataModel = dataModel
        super.init()
    }
    
}
