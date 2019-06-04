//
//  MQLNavigationBar.swift
//  WeiBoII
//
//  Created by ma qianli on 2019/2/26.
//  Copyright © 2019 ma qianli. All rights reserved.
//

import UIKit

class MQLNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            print("UINavigationBar subview-- \(stringFromClass)")
            if stringFromClass.contains("BarBackground") {
                subview.frame = self.bounds
            } else if stringFromClass.contains("UINavigationBarContentView") {
                subview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.cz_screenWidth(), height: self.bounds.height - UIApplication.shared.statusBarFrame.height)
            }
        }
    }

}

