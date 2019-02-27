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
    
    static func initWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> String? {
        return YTTCache.stringForKey(key, timeoutIntervalForCache: interval)
    }
    
    
}

public class YTTCacheString {
    
    private var str: String
    
    init(_ str: String) {
        self.str = str
    }
    
    /// 缓存数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 是否缓存成功
    public func storeWithKey(_ key: String) -> Bool {
        return YTTCache.storeString(str, key: key)
    }
    
}
