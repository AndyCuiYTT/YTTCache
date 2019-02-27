//
//  DictionaryExtension.swift
//  YTTCache
//
//  Created by AndyCui on 2018/11/19.
//

import Foundation

public extension Dictionary {
    public var ytt: YTTCacheDictionary<Key> {
        return YTTCacheDictionary<Key>(self)
    }
    
    static func dictionaryWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude, result: ((Dictionary<Key, Any>?) -> Void)?) {
        
        YTTCache.dataForKey(key, timeoutIntervalForCache: interval) { (data) in
            if let da = data, let dic = try? JSONSerialization.jsonObject(with: da, options: .allowFragments) as? Dictionary<Key, Any> {
                result?(dic)
            }else {
                result?(nil)
            }
        }
    }
    
    
}

public class YTTCacheDictionary<T> where T: Hashable {
    
    private var dictionary: Dictionary<T, Any>
    
    init(_ dictionary: Dictionary<T, Any>) {
        self.dictionary = dictionary
    }
    
    /// 缓存数据
    ///
    /// - key: 键值
    /// - result: 是否缓存成功
    public func storeWithKey(_ key: String, result: ((Bool) -> Void)?) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            YTTCache.storeData(jsonData, key: key, result: result)
        } catch  {
            YTTLog(error)
            result?(false)
        }
    }
    
}
