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
    
    let cellId = "MQLEmotionsCell"
    
    class func emotionsView(keyboardHeight: CGFloat) -> MQLEmotionsView? {
        let nib = UINib(nibName: "MQLEmotionsView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as? MQLEmotionsView
        
        view?.frame = CGRect(x: 0, y: 0, width: 0, height: keyboardHeight)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomConstraintOfBottomToolbar.constant = 34
        if UIApplication.shared.statusBarFrame.height == 20 {
            bottomConstraintOfBottomToolbar.constant = 0
        }
        
        initCollectionView()
    }
    
    func initCollectionView() -> () {
        
        collectionView.backgroundColor = .gray
        
        let nib = UINib(nibName: cellId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }

}

extension MQLEmotionsView : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return MQLEmotionsManager.emotionsManager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return MQLEmotionsManager.emotionsManager.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MQLEmotionsCell ?? MQLEmotionsCell()
        
        cell.cellHeight = bounds.height - bottomConstraintOfBottomToolbar.constant - bottomToolbar.bounds.height
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .red
        case 1:
            cell.backgroundColor = .green
        case 2:
            cell.backgroundColor = .blue
        case 3:
            cell.backgroundColor = .yellow
            
        default:
            cell.backgroundColor = .black
        }
        
        
        return cell
    }
    
    
}