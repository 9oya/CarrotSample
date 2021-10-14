//
//  MemoryCacheService.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation
import UIKit

protocol MemoryCacheServiceProtocol {
    func store(key: String, image: UIImage)
    func fetch(key: String) -> UIImage?
}

class MemoryCacheService: MemoryCacheServiceProtocol {
    
    private let imageCache: NSCache<NSString, UIImage>
    
    init(imageCache: NSCache<NSString, UIImage>) {
        self.imageCache = imageCache
    }
    
    func store(key: String, image: UIImage) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func fetch(key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
