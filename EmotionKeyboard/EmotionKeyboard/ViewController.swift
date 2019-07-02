//
//  ViewController.swift
//  EmotionKeyboard
//
//  Created by maqianli on 2019/7/2.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var lab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let emotion = MQLEmotionsManager.emotionsManager.getEmotionWith(chs: "[男孩儿]")
        lab.attributedText = emotion?.imageText(font: lab.font)
    }


}

