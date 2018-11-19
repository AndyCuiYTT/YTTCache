//
//  DictionaryExtension.swift
//  YTTCache
//
//  Created by AndyCui on 2018/11/19.
//

import Foundation

public extension Dictionary {
    public var cache: YTTCacheDictionary<Key> {
        return YTTCacheDictionary<Key>(self)
    }
    
    static func initWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> Dictionary<Key, Any>? {
        if let data = YTTCache.dataForKey(key, timeoutIntervalForCache: interval) {
            if let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<Key, Any> {
                return dic
            }
        }
        return nil
    }
    
    
}

public class YTTCacheDictionary<T> where T: Hashable {
    
    private var dictionary: Dictionary<T, Any>
    
    init(_ dictionary: Dictionary<T, Any>) {
        self.dictionary = dictionary
    }
    
    /// 缓存数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 是否缓存成功
    public func storeWithKey(_ key: String) -> Bool {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return YTTCache.storeData(jsonData, key: key)
        } catch  {
            YTTLog(error)
        }
        return false
    }
    
}
