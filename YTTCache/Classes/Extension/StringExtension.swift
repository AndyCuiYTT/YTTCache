//
//  StringExtension.swift
//  Pods
//
//  Created by qiuweniOS on 2018/11/19.
//

import Foundation
import CommonCrypto


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
    
    func storeWithKey(_ key: String) -> Bool {
        return YTTCache.storeString(str, key: key)
    }
    
    func MD5() -> String {
        let str = self.str.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.str.lengthOfBytes(using: String.Encoding.utf8))
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
