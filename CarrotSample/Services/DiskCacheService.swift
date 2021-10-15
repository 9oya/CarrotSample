//
//  DiskCacheService.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation
import UIKit

protocol DiskCacheServiceProtocol {
    func store(key: String, image: UIImage)
    func fetch(key: String) -> UIImage?
}

class DiskCacheService: DiskCacheServiceProtocol {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func store(key: String, image: UIImage) {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return
        }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(key)
        
        if !fileManager.fileExists(atPath: filePath.path) {
            fileManager.createFile(atPath: filePath.path,
                                   contents: image.jpegData(compressionQuality: 1.0), attributes: nil)
        }
        
    }
    
    func fetch(key: String) -> UIImage? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(key)
        
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath) else {
                return nil
            }
            guard let image = UIImage(data: imageData) else {
                return nil
            }
            return image
        } else {
            return nil
        }
    }
    
}