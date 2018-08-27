//
//  YTTRequestCache.swift
//  FBSnapshotTestCase
//
//  Created by qiuweniOS on 2018/8/27.
//

import UIKit

public class YTTRequestCache {
    
    
    /// 缓存请求结果 JSON 数据
    ///
    /// - Parameters:
    ///   - jsonStr: JSON 字符串
    ///   - url: 请求 URL 地址
    ///   - param: 请求参数
    /// - Returns: 是否缓存成功
    public class func storeJSONString(_ jsonStr: String, url: String, param: [String: Any]) -> Bool {
        var key = url + "-->"
        param.forEach { (item) in
            key += "\(item.key):\(item.value)"
        }
        if let data = jsonStr.data(using: .utf8) {
            return YTTDataBase().insert(cache_data: data, cache_key: key)
        }
        return false        
    }
    
    
    /// 获取缓存 JSON 数据
    ///
    /// - Parameters:
    ///   - url: 请求 URL 地址
    ///   - param: 请求参数
    ///   - timeoutIntervalForCache: 缓存时间(以秒为单位),默认永久
    /// - Returns: 缓存 JSON 字符串,没有返回 nil
    public class func JSONStringForKey(url: String, param: [String: Any], timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> String? {
        var key = url + "-->"
        param.forEach { (item) in
            key += "\(item.key):\(item.value)"
        }
        if let result = YTTDataBase().select(cache_key: key) {
            if result.time + interval > Date().timeIntervalSince1970 {
                let object = String(data: result.content, encoding: .utf8)
                return object
            }
            let _ = YTTDataBase().delete(cache_key: key)
        }
        return nil
    }
    
    /// 删除某条 JSON 数据
    ///
    /// - Parameters:
    ///   - url: 请求 URL 地址
    ///   - param: 请求参数
    /// - Returns: 是否删除成功
    public class func removeJSONStringForKey(url: String, param: [String: Any]) -> Bool {
        var key = url + "-->"
        param.forEach { (item) in
            key += "\(item.key):\(item.value)"
        }
        return YTTDataBase().delete(cache_key: key)
    }
    
    
    
    

}
