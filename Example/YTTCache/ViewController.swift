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
       
        YTTCache.storeString("qqqqqqqq", key: "1234")
        YTTCache.updateStoreString("吃饭GV哈哈,办好几回,吧", key: "1234")
        print(YTTCache.stringForKey("1234"))
        YTTCache.removeCacheForKey("key")
        YTTCache.cleanCache()
        
        YTTRequestCache.removeJSONStringForKey(url: <#T##String#>, param: <#T##[String : Any]#>)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

