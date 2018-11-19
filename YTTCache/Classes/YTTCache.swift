//
//  YTTCache.swift
//  YTTCache
//
//  Created by AndyCui on 2018/8/23.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit
import CommonCrypto


public class YTTCache {
    
    
    /// 缓存数据
    ///
    /// - Parameters:
    ///   - value: 字符串
    ///   - key: 键值
    /// - Returns: 是否缓存成功
    public class func storeString(_ value: String, key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            return YTTDataBase().insert(cache_data: data, cache_key: key.MD5())
        }
        return false
    }
    
    /// 缓存数据
    ///
    /// - Parameters:
    ///   - value: Data
    ///   - key: 键值
    /// - Returns: 是否缓存成功
    public class func storeData(_ value: Data, key: String) -> Bool {
        return YTTDataBase().insert(cache_data: value, cache_key: key.MD5())
    }
    
    /// 更新缓存数据
    ///
    /// - Parameters:
    ///   - value: 字符串
    ///   - key: 键值
    /// - Returns: 是否更新成功
    public class func updateStoreString(_ value: String, key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            return YTTDataBase().update(cache_data: data, cache_key: key.MD5())
        }
        return false
    }
    
    /// 更新缓存数据
    ///
    /// - Parameters:
    ///   - value: data
    ///   - key: 键值
    /// - Returns: 是否更新成功
    public class func updateStoreData(_ value: Data, key: String) -> Bool {
        return YTTDataBase().update(cache_data: value, cache_key: key.MD5())
    }
   
    /// 获取缓存信息
    ///
    /// - Parameter key: 键值
    /// - Returns: 获取到的 Data
    public class func dataForKey(_ key: String, timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> Data? {
        if let result = YTTDataBase().select(cache_key: key.MD5()) {
            if result.time + interval > Date().timeIntervalSince1970 {
                return result.content
            }
            let _ = YTTDataBase().delete(cache_key: key.MD5())
        }
        return nil
    }
    
    /// 获取缓存信息
    ///
    /// - Parameter key: 键值
    /// - Returns: 获取到的字符串
    public class func stringForKey(_ key: String, timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> String? {
        if let result = YTTDataBase().select(cache_key: key.MD5()) {
            if result.time + interval > Date().timeIntervalSince1970 {
                let object = String(data: result.content, encoding: .utf8)
                return object
            }
            let _ = YTTDataBase().delete(cache_key: key.MD5())
        }
        return nil
    }
    
    /// 清除某条数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 是否清除成功
    public class func removeCacheByKey(_ key: String) -> Bool {
        return YTTDataBase().delete(cache_key: key.MD5())
    }
    
    /// 清除缓存
    ///
    /// - Returns: 是否清除成功
    public class func cleanCache() -> Bool {
        return YTTDataBase().deleteAll()
    }

}

extension String {
    fileprivate func MD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
}
