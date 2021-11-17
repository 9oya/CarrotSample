//
//  ImageFetchService.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/17.
//

import UIKit

protocol ImageFetchServiceProtocol {
    func fetchImage(imgUrl: String,
                    completion: @escaping (UIImage)->Void)
    func defaultImage() -> UIImage
}

class ImageFetchService: ImageFetchServiceProtocol {
    
    var provider: ServiceProvider
    
    init(provider: ServiceProvider) {
        self.provider = provider
    }
    
    func fetchImage(imgUrl: String,
                    completion: @escaping (UIImage)->Void) {
        if let memoryImg = provider
            .memoryCacheService
            .fetch(key: imgUrl) {
            completion(memoryImg)
            return
        } else if let diskImg = provider
                    .diskCacheService
                    .fetch(key: URL(string: imgUrl)!.lastPathComponent) {
            provider
                .memoryCacheService
                .store(key: imgUrl,
                       image: diskImg)
            completion(diskImg)
            return
        }
        _ = provider
            .bookService
            .downloadImage(url: imgUrl) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .notModified(let image):
                    completion(image)
                case let .success(image, etag):
                    self.provider
                        .memoryCacheService
                        .store(key: imgUrl,
                               image: image)
                    _ = self.provider
                        .diskCacheService
                        .store(key: URL(string: imgUrl)!.lastPathComponent,
                               image: image)
                    UserDefaults.standard.set(etag, forKey: imgUrl)
                    completion(image)
                case .failure:
                    break
                }
            }
    }
    
    func defaultImage() -> UIImage {
        return UIImage(named: "default-book")!
    }
}
