//
//  StringExtension.swift
//  Pods
//
//  Created by AndyCui on 2018/11/19.
//

import Foundation


public extension String {
    public var ytt: YTTCacheString {
        return YTTCacheString(self)
    }
    
    static func stringWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude, result: ((String?) -> Void)?) {
        YTTCache.stringForKey(key, timeoutIntervalForCache: interval, result: result)
    }
    
    
}

public class YTTCacheString {
    
    private var str: String
    
    init(_ str: String) {
        self.str = str
    }
    
    /// 缓存数据
    ///
    /// - key: 键值
    /// - result: 是否缓存成功
    public func storeWithKey(_ key: String, result: ((Bool) -> Void)?) {
        return YTTCache.storeString(str, key: key, result: result)
    }
    
}
