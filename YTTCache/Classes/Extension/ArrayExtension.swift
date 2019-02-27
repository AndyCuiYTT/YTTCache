//
//  ArrayExtension.swift
//  YTTCache
//
//  Created by AndyCui on 2018/11/19.
//

import Foundation

public extension Array {
    public var ytt: YTTCacheArray<Element> {
        return YTTCacheArray<Element>(self)
    }
    
    static func arrayWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude, result: ((Array<Element>?) -> Void)?) {
        
        YTTCache.dataForKey(key, timeoutIntervalForCache: interval) { (data) in
            if let da = data, let dic = try? JSONSerialization.jsonObject(with: da, options: .allowFragments) as? Array<Element> {
                result?(dic)
            }else {
                result?(nil)
            }
        }
    }
    
    
}

public class YTTCacheArray<T> {
    
    private var array: Array<T>
    
    init(_ array: Array<T>) {
        self.array = array
    }
    
    /// 缓存数据
    ///
    /// - key: 键值
    /// - result: 是否缓存成功
    public func storeWithKey(_ key: String, result: ((Bool) -> Void)?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
            YTTCache.storeData(jsonData, key: key, result: result)
        } catch  {
            YTTLog(error)
            result?(false)
        }
    }
    
}
