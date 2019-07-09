//
//  MQLEmotionsView.swift
//  EmotionKeyboard
//
//  Created by maqianli on 2019/7/8.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit

class MQLEmotionsView: UIView {

    @IBOutlet weak var bottomToolbar: MQLEmotionsBottomToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomConstraintOfBottomToolbar: NSLayoutConstraint!
    
    class func emotionsView() -> MQLEmotionsView? {
        let nib = UINib(nibName: "MQLEmotionsView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as? MQLEmotionsView
        
        view?.frame = CGRect(x: 0, y: 0, width: 0, height: 346)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomConstraintOfBottomToolbar.constant = 34
        if UIApplication.shared.statusBarFrame.height == 20 {
            bottomConstraintOfBottomToolbar.constant = 0
        }
    }

}
