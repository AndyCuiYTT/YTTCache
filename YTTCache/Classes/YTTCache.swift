//
//  YTTCache.swift
//  YTTCache_Example
//
//  Created by qiuweniOS on 2018/8/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

public class YTTCache {
    
    public class func putString(object: String, key: String) -> Bool {
        if let data = object.data(using: .utf8) {
            return YTTDataBase().insert(cache_data: data, cache_key: key)
        }
        return false
    }
    
    public class func updateString(object: String, key: String) -> Bool {
        if let data = object.data(using: .utf8) {
            return YTTDataBase().update(cache_data: data, cache_key: key)
        }
        return false
    }
   
    public class func getString(key: String) -> String? {
        if let result = YTTDataBase().select(cache_key: key), let object = String(data: result.content, encoding: .utf8) {
            return object
        }
        return nil
    }
    
    public class func cleanCacheByKey(_ key: String) -> Bool {
        return YTTDataBase().delete(cache_key: key)
    }
    
    public class func cleanCache() -> Bool {
        return YTTDataBase().deleteAll()
    }

}
