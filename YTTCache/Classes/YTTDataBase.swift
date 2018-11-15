//
//  YTTDataBase.swift
//  YTTCache
//
//  Created by AndyCui on 2018/8/23.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit
import SQLite
import CommonCrypto

func YTTLog<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
        let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss-SSS"
        let time = formatter.string(from: Date())
        print("\(time) " + fileName + ": " + "\(rowCount)" + " --> \(message)")
    #endif
}

class YTTDataBase {
    
    /// 缓存队列
    private let cacheQueue = DispatchQueue(label: "com.andycui.ytt.cache")
    /// 表格
    private let cacheTb = Table("cacheTb")
    private let id = Expression<Int64>("id")
    /// 缓存数据
    private let cache_data = Expression<Blob>("cache_data")
    /// 缓存键值
    private let cache_key = Expression<String>("cache_key")
    /// 添加缓存时间
    private let cache_time = Expression<Double>("cache_time")
    /// 数据校验字段
    private let cache_data_MD5 = Expression<String>("cache_data_MD5")
    
    /// 获取数据库
    lazy var dataBase: Connection? = {
        // 会自动创建 SQLite 文件,但如果路径不存在创建失败
        if let dbPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            do {
                let db = try Connection(dbPath + "/YTTCache.sqlite3")
                try db.run(cacheTb.create(temporary: false, ifNotExists: true, block: { (t) in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(cache_data)
                    t.column(cache_key, unique: true)
                    t.column(cache_time, defaultValue: Date().timeIntervalSince1970)
                    t.column(cache_data_MD5)
                }))
                return db
            } catch {
                YTTLog(error)
            }
        }
        return nil
    }()
    
    /// 添加数据
    ///
    /// - Parameters:
    ///   - data: 缓存数据
    ///   - key: 数据键值
    /// - Returns: 是否添加成功
    func insert(cache_data data: Data, cache_key key: String) -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                // 插入前先判断是否已有该条数据,存在则删除
                if let count = try dataBase?.scalar(cacheTb.filter(cache_key == key).count), count > 0 {
                    try dataBase?.run(cacheTb.filter(cache_key == key).delete())
                }
                
                let blob = Blob(bytes: (data as NSData).bytes, length: data.count)
                let _ = try dataBase?.run(cacheTb.insert(cache_data <- blob, cache_key <- key, cache_data_MD5 <- MD5(data)))
                result = true
            } catch {
                YTTLog(error)
            }
        }
        return result
    }
    
    /// 查询缓存数据
    ///
    /// - Parameter key: 缓存数据键值
    /// - Returns: 缓存数据与缓存时间
    func select(cache_key key: String) -> (content: Data, time: TimeInterval)? {
        var result: (content: Data, time: TimeInterval)?
        cacheQueue.sync {
            do {
                let query = cacheTb.select(cache_data, cache_time, cache_data_MD5).filter(cache_key == key)
                if let db = dataBase, let row = Array(try db.prepare(query)).first {
                    
                    let data = Data(bytes: row[cache_data].bytes)
                    if MD5(data) == row[cache_data_MD5] {
                        result = (Data(bytes: row[cache_data].bytes), row[cache_time])
                    } else {
                        // 校验失败删除
                        try db.run(cacheTb.filter(cache_key == key).delete())
                    }
                }
            } catch {
                YTTLog(error)
            }
        }
        return result
    }
    
    /// 更新缓存数据
    ///
    /// - Parameters:
    ///   - data: 缓存数据
    ///   - key: 数据键值
    /// - Returns: 是否更新成功
    func update(cache_data data: Data, cache_key key: String) -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                let blob = Blob(bytes: (data as NSData).bytes, length: data.count)
                if let db = dataBase, try db.run(cacheTb.filter(cache_key == key).update(cache_data <- blob, cache_time <- Date().timeIntervalSince1970, cache_data_MD5 <- MD5(data))) > 0 {
                    result = true
                }
            } catch {
                YTTLog(error)
            }
        }
        return result
    }
    
    /// 根据键值删除数据
    ///
    /// - Parameter key: 数据键值
    /// - Returns: 是否删除成功
    func delete(cache_key key: String) -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                if let db = dataBase, try db.run(cacheTb.filter(cache_key == key).delete()) > 0 {
                    result = true
                }
            } catch {
                YTTLog(error)
            }
        }
        return result
    }
    
    /// 删除全部数据
    ///
    /// - Returns: 是否删除成功
    func deleteAll() -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                if let db = dataBase, try db.run(cacheTb.delete()) > 0 {
                    result = true
                }
            } catch {
                YTTLog(error)
            }
        }
        return result
    }
    
    private func MD5(_ data: Data) -> String {
        
        return data.withUnsafeBytes { (cStr: UnsafePointer<UInt8>) -> String in
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(cStr, CC_LONG(data.count), result)
            let resultStr: NSMutableString = NSMutableString()
            for i in 0 ..< Int(CC_MD5_DIGEST_LENGTH) {
                resultStr.appendFormat("%02x", result[i])
            }
            result.deallocate()
            return resultStr as String
        }
    }
}


