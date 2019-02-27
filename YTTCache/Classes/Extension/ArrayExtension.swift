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
    
    static func initWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> Array<Element>? {
        if let data = YTTCache.dataForKey(key, timeoutIntervalForCache: interval) {
            if let array = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Array<Element> {
                return array
            }
        }
        return nil
    }
    
    
}

public class YTTCacheArray<T> {
    
    private var array: Array<T>
    
    init(_ array: Array<T>) {
        self.array = array
    }
    
    /// 缓存数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 是否缓存成功
    public func storeWithKey(_ key: String) -> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
            return YTTCache.storeData(jsonData, key: key)
        } catch  {
            YTTLog(error)
        }
        return false
    }
    
}
