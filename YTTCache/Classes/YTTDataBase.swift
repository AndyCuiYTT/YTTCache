//
//  YTTDataBase.swift
//  YTTCache_Example
//
//  Created by qiuweniOS on 2018/8/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SQLite

class YTTDataBase {
    
    private let cacheQueue = DispatchQueue(label: "com.andycui.ytt.cache")
    private let cacheTb = Table("cacheTb")
    private let id = Expression<Int64>("id")
    private let cache_data = Expression<Blob>("cache_data")
    private let cache_key = Expression<String>("cache_key")
    private let cache_time = Expression<Double>("cache_time")
    
    /// 获取数据库
    lazy var dataBase: Connection? = {
        // 会自动创建 SQLite 文件,但如果路径不存在创建失败
        if let dbPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            do {
                print(dbPath)
                let db = try Connection(dbPath + "/YTTCache.sqlite3")
                try db.run(cacheTb.create(temporary: false, ifNotExists: true, block: { (t) in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(cache_data)
                    t.column(cache_key, unique: true)
                    t.column(cache_time, defaultValue: Date().timeIntervalSince1970)
                }))
                return db
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }()
    
    func insert(cache_data data: Data, cache_key key: String) -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                let blob = Blob(bytes: (data as NSData).bytes, length: data.count)
                let _ = try dataBase?.run(cacheTb.insert(cache_data <- blob, cache_key <- key))
                result = true
            } catch {
                print(error)
            }
        }
        return result
    }
    
    func select(cache_key key: String) -> (content: Data, time: TimeInterval)? {
        var result: (content: Data, time: TimeInterval)?
        cacheQueue.sync {
            do {
                let query = cacheTb.select(cache_data, cache_time).filter(cache_key == key)
                if let db = dataBase, let row = Array(try db.prepare(query)).first {
                   result = (Data(bytes: row[cache_data].bytes), row[cache_time])
                }
            } catch {
                print(error)
            }
        }
        return result
    }
    
    func update(cache_data data: Data, cache_key key: String) -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                let blob = Blob(bytes: (data as NSData).bytes, length: data.count)
                if let db = dataBase, try db.run(cacheTb.filter(cache_key == key).update(cache_data <- blob, cache_time <- Date().timeIntervalSince1970)) > 0 {
                    result = true
                }
            } catch {
                print(error)
            }
        }
        return result
    }
    
    func delete(cache_key key: String) -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                if let db = dataBase, try db.run(cacheTb.filter(cache_key == key).delete()) > 0 {
                    result = true
                }
            } catch {
                print(error)
            }
        }
        return result
    }
    
    func deleteAll() -> Bool {
        var result: Bool = false
        cacheQueue.sync {
            do {
                if let db = dataBase, try db.run(cacheTb.delete()) > 0 {
                    result = true
                }
            } catch {
            print(error)
            }
        }
        return result
    }
}
