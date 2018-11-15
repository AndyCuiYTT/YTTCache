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
//
//        YTTCache.storeString("1234", key: "1234")
//        YTTCache.storeString("1234", key: "QQQQQQ")
//        YTTCache.updateStoreString("吃饭GV哈哈,办好几回,吧", key: "1234")
//        print(YTTCache.stringForKey("1234"))
//        print(YTTCache.stringForKey("QQQQQQ"))
//        YTTCache.removeCacheForKey("key")
//        YTTCache.cleanCache()
        
        YTTRequestCache.storeJSONString("{'name':'Andy','age':23}", url: "http://www.baidu.com", param: ["UID" : 00001])
        print(YTTRequestCache.JSONStringForKey(url: "http://www.baidu.com", param: ["UID" : 00001]))
        
//        YTTRequestCache.removeJSONStringForKey(url: <#T##String#>, param: <#T##[String : Any]#>)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

