//
//  Cache.swift
//  CacheDemo
//
//  Created by Nguyen Cong Huy on 7/4/16.
//  Copyright © 2016 Nguyen Cong Huy. All rights reserved.
//

import UIKit

public enum ImageFormat {
    case unknown, png, jpeg
}

open class DataCache {
    static let cacheDirectoryPrefix = "com.nch.cache."
    static let ioQueuePrefix = "com.nch.queue."
    static let defaultMaxCachePeriodInSecond: TimeInterval = 60 * 60 * 24 * 7         // a week
    
    public static var instance = DataCache(name: "default")
    
    var cachePath: String
    
    let memCache = NSCache<AnyObject, AnyObject>()
    let ioQueue: DispatchQueue
    let fileManager: FileManager
    
    /// Name of cache
    open var name: String = ""
    
    /// Life time of disk cache, in second. Default is a week
    open var maxCachePeriodInSecond = DataCache.defaultMaxCachePeriodInSecond
    
    /// Size is allocated for disk cache, in byte. 0 mean no limit. Default is 0
    open var maxDiskCacheSize: UInt = 0
    
    /// Specify distinc name param, it represents folder name for disk cache
    public init(name: String, path: String? = nil) {
        self.name = name
        
        cachePath = path ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        cachePath = (cachePath as NSString).appendingPathComponent(DataCache.cacheDirectoryPrefix + name)
        
        ioQueue = DispatchQueue(label: DataCache.ioQueuePrefix + name)
        
        self.fileManager = FileManager()
        
        #if !os(OSX) && !os(watchOS)
            NotificationCenter.default.addObserver(self, selector: #selector(DataCache.cleanExpiredDiskCache), name: UIApplication.willTerminateNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(DataCache.cleanExpiredDiskCache), name: UIApplication.didEnterBackgroundNotification, object: nil)
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Store data

extension DataCache {
    
    /// Write data for key. This is an async operation.
    public func write(data: Data, forKey key: String) {
        memCache.setObject(data as AnyObject, forKey: key as AnyObject)
        writeDataToDisk(data: data, key: key)
    }
    
    func writeDataToDisk(data: Data, key: String) {
        ioQueue.async {
            if self.fileManager.fileExists(atPath: self.cachePath) == false {
                do {
                    try self.fileManager.createDirectory(atPath: self.cachePath, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    print("Error while creating cache folder")
                }
            }
            
            self.fileManager.createFile(atPath: self.cachePath(forKey: key), contents: data, attributes: nil)
        }
    }
    
    /// Read data for key
    public func readData(forKey key:String) -> Data? {
        var data = memCache.object(forKey: key as AnyObject) as? Data
        
        if data == nil {
            if let dataFromDisk = readDataFromDisk(forKey: key) {
                data = dataFromDisk
                memCache.setObject(dataFromDisk as AnyObject, forKey: key as AnyObject)
            }
        }
        
        return data
    }
    
    /// Read data from disk for key
    public func readDataFromDisk(forKey key: String) -> Data? {
        return self.fileManager.contents(atPath: cachePath(forKey: key))
    }
    
    
    // MARK: Read & write utils
    
    
    /// Write an object for key. This object must inherit from `NSObject` and implement `NSCoding` protocol. `String`, `Array`, `Dictionary` conform to this method.
    ///
    /// NOTE: Can't write `UIImage` with this method. Please use `writeImage(_:forKey:)` to write an image
    public func write(object: NSCoding, forKey key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        write(data: data, forKey: key)
    }
    
    /// Write a string for key
    public func write(string: String, forKey key: String) {
        write(object: string as NSCoding, forKey: key)
    }
    
    /// Write a dictionary for key
    public func write(dictionary: Dictionary<AnyHashable, Any>, forKey key: String) {
        write(object: dictionary as NSCoding, forKey: key)
    }
    
    /// Write an array for key
    public func write(array: Array<Any>, forKey key: String) {
        write(object: array as NSCoding, forKey: key)
    }
    
    /// Read an object for key. This object must inherit from `NSObject` and implement NSCoding protocol. `String`, `Array`, `Dictionary` conform to this method
    public func readObject(forKey key: String) -> NSObject? {
        let data = readData(forKey: key)
        
        if let data = data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSObject
        }
        
        return nil
    }
    
    /// Read a string for key
    public func readString(forKey key: String) -> String? {
        return readObject(forKey: key) as? String
    }
    
    /// Read an array for key
    public func readArray(forKey key: String) -> Array<Any>? {
        return readObject(forKey: key) as? Array<Any>
    }
    
    /// Read a dictionary for key
    public func readDictionary(forKey key: String) -> Dictionary<AnyHashable, Any>? {
        return readObject(forKey: key) as? Dictionary<AnyHashable, Any>
    }
    
    // MARK: Read & write image
    
    /// Write image for key. Please use this method to write an image instead of `writeObject(_:forKey:)`
    public func write(image: UIImage, forKey key: String, format: ImageFormat? = nil) {
        var data: Data? = nil
        
        if let format = format, format == .png {
            data = image.pngData()
        }
        else {
            data = image.jpegData(compressionQuality: 0.9)
        }
        
        if let data = data {
            write(data: data, forKey: key)
        }
    }
    
    /// Read image for key. Please use this method to write an image instead of `readObjectForKey(_:)`
    public func readImageForKey(key: String) -> UIImage? {
        let data = readData(forKey: key)
        if let data = data {
            return UIImage(data: data, scale: 1.0)
        }
        
        return nil
    }
}

// MARK: Utils

extension DataCache {
    
    /// Check if has data on disk
    public func hasDataOnDisk(forKey key: String) -> Bool {
        return self.fileManager.fileExists(atPath: self.cachePath(forKey: key))
    }
    
    /// Check if has data on mem
    public func hasDataOnMem(forKey key: String) -> Bool {
        return (memCache.object(forKey: key as AnyObject) != nil)
    }
}

// MARK: Clean

extension DataCache {
    
    /// Clean all mem cache and disk cache. This is an async operation.
    public func cleanAll() {
        cleanMemCache()
        cleanDiskCache()
    }
    
    /// Clean cache by key. This is an async operation.
    public func clean(byKey key: String) {
        memCache.removeObject(forKey: key as AnyObject)
        
        ioQueue.async {
            do {
                try self.fileManager.removeItem(atPath: self.cachePath(forKey: key))
            } catch {}
        }
    }
    
    public func cleanMemCache() {
        memCache.removeAllObjects()
    }
    
    public func cleanDiskCache() {
        ioQueue.async {
            do {
                try self.fileManager.removeItem(atPath: self.cachePath)
            } catch {}
        }
    }
    
    /// Clean expired disk cache. This is an async operation.
    @objc public func cleanExpiredDiskCache() {
        cleanExpiredDiskCache(completion: nil)
    }
    
    // This method is from Kingfisher
    /**
     Clean expired disk cache. This is an async operation.
     
     - parameter completionHandler: Called after the operation completes.
     */
    open func cleanExpiredDiskCache(completion handler: (()->())? = nil) {
        
        // Do things in cocurrent io queue
        ioQueue.async {
            
            var (URLsToDelete, diskCacheSize, cachedFiles) = self.travelCachedFiles(onlyForCacheSize: false)
            
            for fileURL in URLsToDelete {
                do {
                    try self.fileManager.removeItem(at: fileURL)
                } catch _ { }
            }
            
            if self.maxDiskCacheSize > 0 && diskCacheSize > self.maxDiskCacheSize {
                let targetSize = self.maxDiskCacheSize / 2
                
                // Sort files by last modify date. We want to clean from the oldest files.
                let sortedFiles = cachedFiles.keysSortedByValue {
                    resourceValue1, resourceValue2 -> Bool in
                    
                    if let date1 = resourceValue1.contentAccessDate,
                       let date2 = resourceValue2.contentAccessDate
                    {
                        return date1.compare(date2) == .orderedAscending
                    }
                    
                    // Not valid date information. This should not happen. Just in case.
                    return true
                }
                
                for fileURL in sortedFiles {
                    
                    do {
                        try self.fileManager.removeItem(at: fileURL)
                    } catch { }
                    
                    URLsToDelete.append(fileURL)
                    
                    if let fileSize = cachedFiles[fileURL]?.totalFileAllocatedSize {
                        diskCacheSize -= UInt(fileSize)
                    }
                    
                    if diskCacheSize < targetSize {
                        break
                    }
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                handler?()
            })
        }
    }
}

// MARK: Helpers

extension DataCache {
    
    // This method is from Kingfisher
    fileprivate func travelCachedFiles(onlyForCacheSize: Bool) -> (urlsToDelete: [URL], diskCacheSize: UInt, cachedFiles: [URL: URLResourceValues]) {
        
        let diskCacheURL = URL(fileURLWithPath: cachePath)
        let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey, .contentAccessDateKey, .totalFileAllocatedSizeKey]
        let expiredDate: Date? = (maxCachePeriodInSecond < 0) ? nil : Date(timeIntervalSinceNow: -maxCachePeriodInSecond)
        
        var cachedFiles = [URL: URLResourceValues]()
        var urlsToDelete = [URL]()
        var diskCacheSize: UInt = 0
        
        for fileUrl in (try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)) ?? [] {
            
            do {
                let resourceValues = try fileUrl.resourceValues(forKeys: resourceKeys)
                // If it is a Directory. Continue to next file URL.
                if resourceValues.isDirectory == true {
                    continue
                }
                
                // If this file is expired, add it to URLsToDelete
                if !onlyForCacheSize,
                    let expiredDate = expiredDate,
                    let lastAccessData = resourceValues.contentAccessDate,
                    (lastAccessData as NSDate).laterDate(expiredDate) == expiredDate
                {
                    urlsToDelete.append(fileUrl)
                    continue
                }
                
                if let fileSize = resourceValues.totalFileAllocatedSize {
                    diskCacheSize += UInt(fileSize)
                    if !onlyForCacheSize {
                        cachedFiles[fileUrl] = resourceValues
                    }
                }
            } catch _ { }
        }
        
        return (urlsToDelete, diskCacheSize, cachedFiles)
    }
    
    func cachePath(forKey key: String) -> String {
        let fileName = key.md5
        return (cachePath as NSString).appendingPathComponent(fileName)
    }
}
