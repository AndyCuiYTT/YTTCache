//
//  YTTRequestCache.swift
//  YTTCache
//
//  Created by AndyCui on 2018/8/27.
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
        do {
            let paramData = try JSONSerialization.data(withJSONObject: param, options: [])
            if let paramStr = String(data: paramData, encoding: .utf8) {
                return YTTCache.storeString(jsonStr, key: url + "-->" + paramStr)
            }
        } catch {
            YTTLog(error)
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
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
            if let jsonStr = String(data: jsonData, encoding: .utf8) {
                return YTTCache.stringForKey(url + "-->" + jsonStr, timeoutIntervalForCache: interval)
            }
        } catch {
            YTTLog(error)
        }
        return nil
    }
    
    /// 删除某条 JSON 数据
    ///
    /// - Parameters:
    ///   - url: 请求 URL 地址
    ///   - param: 请求参数
    /// - Returns: 是否删除成功
    public class func removeJSONStringByKey(url: String, param: [String: Any]) -> Bool {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
            if let jsonStr = String(data: jsonData, encoding: .utf8) {
                return YTTCache.removeCacheByKey(url + "-->" + jsonStr)
            }
        } catch {
            YTTLog(error)
        }
        return false
    }
    
    
    
    

}
