//
//  NSAttributedString+extension.swift
//  MicroBlog
//
//  Created by maqianli on 2019/7/3.
//  Copyright © 2019 qianli. All rights reserved.
//

import Foundation

extension NSAttributedString {
    /// 根据字体，指定宽度、指定高度获取size
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: size
    func size(width: CGFloat, height: CGFloat) -> CGSize {
        
        let rect = boundingRect(with: CGSize(width: width, height: height),
                                options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading],  context: nil)
        return CGSize(width: ceil(rect.size.width) + 1, height: ceil(rect.size.height) + 1)
    }
}


