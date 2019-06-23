//
//  NSStrin+extension.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/23.
//  Copyright © 2019 qianli. All rights reserved.
//

import Foundation

extension NSString {
    
    
    /// 根据字体，指定宽度、指定高度获取size
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: size
    func size(font: UIFont, width: CGFloat, height: CGFloat) -> CGSize {
        let rect = boundingRect(with: CGSize(width: width, height: height), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil)
        return CGSize(width: ceil(rect.size.width) + 1, height: ceil(rect.size.height) + 1)
    }
}














