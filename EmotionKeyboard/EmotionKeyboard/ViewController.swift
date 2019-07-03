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
        lab.attributedText = MQLEmotionsManager.emotionsManager.emotionString(string: "我[笑哈哈]你[马到成功]啊", font: lab.font)

    }

    

}




















