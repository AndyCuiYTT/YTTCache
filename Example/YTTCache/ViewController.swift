//
//  ViewController.swift
//  YTTCache
//
//  Created by AndyCuiYTT on 08/23/2018.
//  Copyright (c) 2018 AndyCuiYTT. All rights reserved.
//

import UIKit
import YTTCache

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        YTTCache.putString(object: "qqqqqqqq", key: "1234")
        YTTCache.updateString(object: "吃饭GV哈哈,办好几回,吧", key: "1234")
        print(YTTCache.getString(key: "1234"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

