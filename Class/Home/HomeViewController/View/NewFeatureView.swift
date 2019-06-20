//
//  NewFeatureView.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/18.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import TYCyclePagerView

class NewFeatureView: UIView {
    
    @IBOutlet weak var cyclePagerViewContainer: UIView!
    
    var pagerView: TYCyclePagerView?
    var pageControl: TYPageControl?
    var numberOfItems: Int = 4
    
    class func newFeatureView() -> NewFeatureView? {
        let view = UINib(nibName: "NewFeatureView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NewFeatureView
        view?.frame = UIScreen.main.bounds
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPagerView()
        addPageControl()
    }
}


// MARK: - TYCyclePagerView相关
extension NewFeatureView : TYCyclePagerViewDataSource, TYCyclePagerViewDelegate {
    
    func addPagerView() -> () {
        pagerView = TYCyclePagerView()
        pagerView?.isInfiniteLoop = false
        pagerView?.autoScrollInterval = 0.0
        
        pagerView?.dataSource = self
        pagerView?.delegate = self
        
        let nib = UINib(nibName: "NewFeatureCollectionViewCell", bundle: nil)
        pagerView?.register(nib, forCellWithReuseIdentifier: "NewFeatureCollectionViewCell")
        
        guard let pagerView = pagerView else {
            return
        }
        cyclePagerViewContainer.addSubview(pagerView)
        pagerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func addPageControl() -> () {
        
        pageControl = TYPageControl()
        pageControl?.currentPageIndicatorSize = CGSize(width: 6, height: 6)
        pageControl?.pageIndicatorSize = CGSize(width: 6, height: 6)
        pageControl?.currentPageIndicatorTintColor = .red
        pageControl?.pageIndicatorTintColor = .gray
        pageControl?.numberOfPages = numberOfItems;
        
        guard let pageControl = pageControl,
         let pagerView = pagerView else {
            return
        }
        
        pagerView.addSubview(pageControl)
        layoutIfNeeded()
        
        pageControl.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    //MARK：TYCyclePagerViewDataSource
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return numberOfItems
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "NewFeatureCollectionViewCell", for: index) as? NewFeatureCollectionViewCell
        cell?.pageNumber = index
        
        return cell != nil ? cell! : UICollectionViewCell()
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = pageView.bounds.size
        return layout
    }
    
    //MARK：TYCyclePagerViewDelegate
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        pageControl?.currentPage = toIndex
    }
    
    func pagerViewWillBeginDecelerating(_ pageView: TYCyclePagerView) {
        if pageControl?.currentPage == 3 {
            print("------")
            removeFromSuperview()
        }
    }


}
