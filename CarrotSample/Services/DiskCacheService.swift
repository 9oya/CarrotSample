//
//  DiskCacheService.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation
import UIKit

protocol DiskCacheServiceProtocol {
    func store(key: String, image: UIImage) -> Bool
    func fetch(key: String) -> UIImage?
}

class DiskCacheService: DiskCacheServiceProtocol {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func store(key: String, image: UIImage) -> Bool {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return false
        }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(key)
        
        if !fileManager.fileExists(atPath: filePath.path) {
            return fileManager.createFile(atPath: filePath.path,
                                   contents: image.pngData(), attributes: nil)
        }
        return false
    }
    
    func fetch(key: String) -> UIImage? {
        if let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                          .userDomainMask,
                                                          true).first {
            var filePath = URL(fileURLWithPath: path)
            filePath.appendPathComponent(key)
            if fileManager.fileExists(atPath: filePath.path),
               let imageData = try? Data(contentsOf: filePath),
               let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
    
}
