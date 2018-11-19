//
//  UIImageExtension.swift
//  YTTCache
//
//  Created by AndyCui on 2018/11/19.
//

import Foundation

public extension UIImage {
    public var cache: YTTCacheUIImage {
        return YTTCacheUIImage(self)
    }
    
    static func initWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> UIImage? {
        if let data = YTTCache.dataForKey(key, timeoutIntervalForCache: interval) {
            return UIImage(data: data)
        }
        return nil
    }
    
    
}

public class YTTCacheUIImage {
    
    private var image: UIImage
    
    init(_ image: UIImage) {
        self.image = image
    }
    
    /// 缓存数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 是否缓存成功
    public func storeWithKey(_ key: String) -> Bool {
        if let data = image.pngData() {
            return YTTCache.storeData(data, key: key)
        }
        return false
    }
    
}
