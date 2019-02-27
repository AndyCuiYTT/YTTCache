//
//  UIImageExtension.swift
//  YTTCache
//
//  Created by AndyCui on 2018/11/19.
//

import Foundation

public extension UIImage {
    public var ytt: YTTCacheUIImage {
        return YTTCacheUIImage(self)
    }
    
    static func imageWithCache(_ key: String,  timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude, result: ((UIImage?) -> Void)?) {
        
        YTTCache.dataForKey(key, timeoutIntervalForCache: interval) { (data) in
            if let da = data, let image = UIImage(data: da) {
                result?(image)
            }else {
                result?(nil)
            }
        }
    }
}

public class YTTCacheUIImage {
    
    private var image: UIImage
    
    init(_ image: UIImage) {
        self.image = image
    }
    
    /// 缓存数据
    ///
    /// - key: 键值
    /// - result: 是否缓存成功
    public func storeWithKey(_ key: String, result: ((Bool) -> Void)?) {
        if let data = image.pngData() {
            return YTTCache.storeData(data, key: key, result: result)
        }else {
            result?(false)
        }
    }
    
}
