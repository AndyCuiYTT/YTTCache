//
//  YTTCache.swift
//  YTTCache
//
//  Created by AndyCui on 2018/8/23.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

public class YTTCache {
    
    
    /// 缓存数据
    ///
    /// - Parameters:
    ///   - value: 字符串
    ///   - key: 键值
    /// - Returns: 是否缓存成功
    public class func storeString(_ value: String, key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            return YTTDataBase().insert(cache_data: data, cache_key: key)
        }
        return false
    }
    
    /// 更新缓存数据
    ///
    /// - Parameters:
    ///   - value: 字符串
    ///   - key: 键值
    /// - Returns: 是否更新成功
    public class func updateStoreString(_ value: String, key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            return YTTDataBase().update(cache_data: data, cache_key: key)
        }
        return false
    }
   
    /// 获取缓存信息
    ///
    /// - Parameter key: 键值
    /// - Returns: 获取到的字符串
    public class func stringForKey(_ key: String) -> String? {
        if let result = YTTDataBase().select(cache_key: key), let object = String(data: result.content, encoding: .utf8) {
            return object
        }
        return nil
    }
    
    /// 清除某条数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 是否清除成功
    public class func removeCacheForKey(_ key: String) -> Bool {
        return YTTDataBase().delete(cache_key: key)
    }
    
    /// 清除缓存
    ///
    /// - Returns: 是否清除成功
    public class func cleanCache() -> Bool {
        return YTTDataBase().deleteAll()
    }

}
